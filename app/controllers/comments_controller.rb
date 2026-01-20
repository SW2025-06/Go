class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:review_id].present?
      # レビューへのコメント
      review = Review.find(params[:review_id])
      comment = review.comments.build(comment_params)
      comment.user = current_user
    else
      # コメントへの返信
      parent = Comment.find(params[:comment_id])
      comment = parent.review.comments.build(comment_params)
      comment.user = current_user
      comment.parent = parent
    end

    if comment.save
      redirect_back fallback_location: review_path(comment.review), notice: "コメントを投稿しました"
    else
      redirect_back fallback_location: review_path(comment.review), alert: comment.errors.full_messages.join(", ")
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
