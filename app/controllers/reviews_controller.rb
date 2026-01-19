# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = Review.order(created_at: :desc)
    @reviews = @reviews.where(genre: params[:genre]) if params[:genre].present?
    @reviews = @reviews.where(platform: params[:platform]) if params[:platform].present?
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

  def review_params
    params.require(:review).permit(:title, :body, :genre, :platform, :jacket, :rating, :purchase_url, :game_id)
  end
end