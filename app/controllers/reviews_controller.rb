# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

def index
  @reviews = Review
    .includes(:user)   # ← 追加（N+1対策 & username検索に必須）
    .order(created_at: :desc)

  # ジャンル / プラットフォームの絞り込み（既存）
  @reviews = @reviews.where(genre: params[:genre]) if params[:genre].present?
  @reviews = @reviews.where(platform: params[:platform]) if params[:platform].present?

  # 検索（タイトル・本文・購入先URL・投稿者ユーザー名）
  if params[:q].present?
    q = params[:q].to_s.strip.downcase
    q_escaped = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"

    @reviews = @reviews
      .joins(:user)
      .where(
        <<~SQL,
          lower(reviews.title)        LIKE :q
          OR lower(reviews.body)      LIKE :q
          OR lower(reviews.purchase_url) LIKE :q
          OR lower(users.username)    LIKE :q
        SQL
        q: q_escaped
      )
  end
end

  def show
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