# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]
  
# reviews_controller.rb
def index
  @reviews = Review.all

  # ここ：平均点を取る（group は reviews.id のみ）
  @reviews = @reviews
    .left_joins(:review_ratings)
    .select(
      "reviews.*,
       AVG(review_ratings.helpfulness) AS avg_helpfulness,
       AVG(review_ratings.want_to_play) AS avg_want_to_play,
       AVG(review_ratings.recommend_to_friend) AS avg_recommend_to_friend"
    )
    .group("reviews.id")

  # ここ：検索（title/body + username）を安全に
  if params[:q].present?
    q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].to_s.downcase)}%"

    @reviews = @reviews.where(
      <<~SQL, q: q
        lower(reviews.title) LIKE :q
        OR lower(reviews.body) LIKE :q
        OR EXISTS (
          SELECT 1 FROM users
          WHERE users.id = reviews.user_id
          AND lower(users.username) LIKE :q
        )
      SQL
    )
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