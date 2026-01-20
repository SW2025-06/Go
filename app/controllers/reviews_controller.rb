# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]
  
def index
  base = Review.all

  # 1) 絞り込み（まずは素の reviews に対して）
  base = base.where(genre: params[:genre]) if params[:genre].present?
  base = base.where(platform: params[:platform]) if params[:platform].present?

  # 2) 検索（title/body + username を EXISTS で）
  if params[:q].present?
    q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].to_s.downcase)}%"

    base = base.where(
      <<~SQL, q: q
        lower(reviews.title) LIKE :q
        OR lower(reviews.body) LIKE :q
        OR EXISTS (
          SELECT 1 FROM users
          WHERE users.id = reviews.user_id
          AND lower(coalesce(users.username, '')) LIKE :q
        )
      SQL
    )
  end

  # 3) 平均点（review_ratings を join して select / group）
  @reviews = base
    .left_joins(:review_ratings)
    .select(
      "reviews.*,
       COALESCE(AVG(review_ratings.helpfulness), 0) AS avg_helpfulness,
       COALESCE(AVG(review_ratings.want_to_play), 0) AS avg_want_to_play,
       COALESCE(AVG(review_ratings.recommend_to_friend), 0) AS avg_recommend_to_friend"
    )
    .group("reviews.id")
    .with_attached_jacket

  # 4) ソート（params[:sort] で分岐）
  case params[:sort]
  when "new"
    @reviews = @reviews.order(created_at: :desc)
  when "helpfulness"
    @reviews = @reviews.order(Arel.sql("avg_helpfulness DESC, reviews.created_at DESC"))
  when "want_to_play"
    @reviews = @reviews.order(Arel.sql("avg_want_to_play DESC, reviews.created_at DESC"))
  when "recommend"
    @reviews = @reviews.order(Arel.sql("avg_recommend_to_friend DESC, reviews.created_at DESC"))
  else
    @reviews = @reviews.order(created_at: :desc)
  end
end

  # 画像等の表示が重いならここで preload
  @reviews = @reviews.with_attached_jacket
end

  def show
    @review = Review.includes(comments: [:user, :comment_ratings, replies: [:user, :comment_ratings]]).find(params[:id])

    if user_signed_in?
      @my_rating = current_user.review_ratings.find_or_initialize_by(review: @review)
    end
  
    @new_comment = Comment.new
    @comment_tree = @review.comments.where(parent_id: nil).order(created_at: :desc)
    @avg_helpfulness = @review.review_ratings.average(:helpfulness)&.to_f
    @avg_want_to_play = @review.review_ratings.average(:want_to_play)&.to_f
    @avg_recommend_to_friend = @review.review_ratings.average(:recommend_to_friend)&.to_f
    
  end

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to @review, notice: "レビューを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # 必要なら権限制御: redirect unless @review.user == current_user
  end

  def update
    if @review.update(review_params)
      redirect_to @review, notice: "レビューを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_path, notice: "レビューを削除しました"
  end

  private

  def set_review
    @review = Review.find_by(id: params[:id])
    unless @review
      redirect_to reviews_path, alert: "レビューが見つかりません"
    end
  end
  
    # 投稿者のみが編集・削除できるようにするメソッド
  def authorize_owner!
    # @review は set_review でセット済みのはず
    unless @review && user_signed_in? && @review.user == current_user
      # やさしく弾く／不正アクセスは一覧へ戻す
      redirect_to(@review || reviews_path, alert: "この操作は投稿者のみ可能です")
    end
  end

  def review_params
    params.require(:review).permit(:title, :body, :genre, :platform, :jacket, :rating, :purchase_url, :game_id)
  end
end