class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

<<<<<<< HEAD
  def index
    @reviews = Review.order(created_at: :desc).limit(50)
    @review = Review.new
  end

  def new
    @review = Review.new
    # new.html.erb は turbo_frame 内でレンダリングされる想定
    render partial: "form", locals: { review: @review }
  end

  def create
    @review = current_user.reviews.build(review_params)

    respond_to do |format|
      if @review.save
        format.turbo_stream do
          # prepend でリスト先頭に追加するテンプレを返す（下でファイル例あり）
          render turbo_stream: [
            turbo_stream.prepend("reviews_list", partial: "reviews/review", locals: { review: @review }),
            turbo_stream.replace("new_review", partial: "reviews/new_link") # フォームを消して "New" リンクに戻す例
          ]
        end
        format.html { redirect_to reviews_path, notice: "レビューを作成しました。" }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_review", partial: "reviews/form", locals: { review: @review }), status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  # オプション: 個別表示や削除
  def show
    @review = Review.find(params[:id])
  end

  def destroy
    @review = current_user.reviews.find(params[:id])
    @review.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@review)) }
      format.html { redirect_to reviews_path, notice: "削除しました" }
    end
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

  def review_params
    params.require(:review).permit(:title, :body)
  end
  
end
  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:title, :body, :rating, :user_id, :game_id, :platform, :genre)
  end
end

