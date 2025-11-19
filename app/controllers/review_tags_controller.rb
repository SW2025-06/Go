class ReviewTagsController < ApplicationController
  before_action :set_review_tag, only: %i[ show edit update destroy ]

  # GET /review_tags or /review_tags.json
  def index
    @review_tags = ReviewTag.all
  end

  # GET /review_tags/1 or /review_tags/1.json
  def show
  end

  # GET /review_tags/new
  def new
    @review_tag = ReviewTag.new
  end

  # GET /review_tags/1/edit
  def edit
  end

  # POST /review_tags or /review_tags.json
  def create
    @review_tag = ReviewTag.new(review_tag_params)

    respond_to do |format|
      if @review_tag.save
        format.html { redirect_to @review_tag, notice: "Review tag was successfully created." }
        format.json { render :show, status: :created, location: @review_tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_tags/1 or /review_tags/1.json
  def update
    respond_to do |format|
      if @review_tag.update(review_tag_params)
        format.html { redirect_to @review_tag, notice: "Review tag was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @review_tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_tags/1 or /review_tags/1.json
  def destroy
    @review_tag.destroy!

    respond_to do |format|
      format.html { redirect_to review_tags_path, notice: "Review tag was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_tag
      @review_tag = ReviewTag.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def review_tag_params
      params.expect(review_tag: [ :review_id, :tag_id ])
    end
end
