class ReviewRatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def upsert
    rating = current_user.review_ratings.find_or_initialize_by(review: @review)
    rating.assign_attributes(review_rating_params)

    if rating.save
      redirect_to review_path(@review), notice: "評価を保存しました"
    else
      # show側で表示するために必要な変数を再セットしたい場合は show に寄せる
      redirect_to review_path(@review), alert: rating.errors.full_messages.join(", ")
    end
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def review_rating_params
    params.require(:review_rating).permit(:helpfulness, :want_to_play, :recommend_to_friend)
  end
end

