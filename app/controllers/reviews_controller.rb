class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews
  def index
    @reviews = Review.order(created_at: :desc)
    @reviews = @reviews.order(rating: :desc) if params[:sort] == "rating"
    @side_highlights = Review.order(Arel.sql("RANDOM()")).limit(2) # DB に合わせて変更可
  end

  def show; end
  def new; @review = Review.new; end
  def edit; end

  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to @review, notice: "Review was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      redirect_to @review, notice: "Review was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy!
    redirect_to reviews_path, notice: "Review was successfully destroyed.", status: :see_other
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:title, :body, :rating, :user_id, :game_id, :platform, :genre)
  end
end

