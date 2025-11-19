require "test_helper"

class ReviewTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review_tag = review_tags(:one)
  end

  test "should get index" do
    get review_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_review_tag_url
    assert_response :success
  end

  test "should create review_tag" do
    assert_difference("ReviewTag.count") do
      post review_tags_url, params: { review_tag: { review_id: @review_tag.review_id, tag_id: @review_tag.tag_id } }
    end

    assert_redirected_to review_tag_url(ReviewTag.last)
  end

  test "should show review_tag" do
    get review_tag_url(@review_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_tag_url(@review_tag)
    assert_response :success
  end

  test "should update review_tag" do
    patch review_tag_url(@review_tag), params: { review_tag: { review_id: @review_tag.review_id, tag_id: @review_tag.tag_id } }
    assert_redirected_to review_tag_url(@review_tag)
  end

  test "should destroy review_tag" do
    assert_difference("ReviewTag.count", -1) do
      delete review_tag_url(@review_tag)
    end

    assert_redirected_to review_tags_url
  end
end
