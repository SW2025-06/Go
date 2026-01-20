class CommentRatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def upsert
    rating = current_user.comment_ratings.find_or_initialize_by(comment: @comment)
    rating.assign_attributes(comment_rating_params)

    if rating.save
      redirect_back fallback_location: review_path(@comment.review), notice: "評価を保存しました"
    else
      redirect_back fallback_location: review_path(@comment.review), alert: rating.errors.full_messages.join(", ")
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def comment_rating_params
    params.require(:comment_rating).permit(:stars, :helpfulness)
  end
end
