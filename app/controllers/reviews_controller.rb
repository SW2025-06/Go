class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @reviews = Review.order(created_at: :desc)
    @review = Review.new
  end

  def new
    @review = Review.new
    render partial: "form", locals: { review: @review }
  end
  
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_path, notice: "レビューを削除しました" }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@review)) }
    end
  end

  def create
    @review = current_user.reviews.build(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to reviews_path, notice: "レビューを作成しました" }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("reviews_list", partial: "reviews/review", locals: { review: @review }),
            turbo_stream.replace("new_review", partial: "reviews/new_link")
          ]
        end
      else
        format.html { render :index, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_review", partial: "reviews/form", locals: { review: @review }), status: :unprocessable_entity }
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :genre, :platform, :jacket, :rating)
  end
end