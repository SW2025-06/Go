require "application_system_test_case"

class ReviewTagsTest < ApplicationSystemTestCase
  setup do
    @review_tag = review_tags(:one)
  end

  test "visiting the index" do
    visit review_tags_url
    assert_selector "h1", text: "Review tags"
  end

  test "should create review tag" do
    visit review_tags_url
    click_on "New review tag"

    fill_in "Review", with: @review_tag.review_id
    fill_in "Tag", with: @review_tag.tag_id
    click_on "Create Review tag"

    assert_text "Review tag was successfully created"
    click_on "Back"
  end

  test "should update Review tag" do
    visit review_tag_url(@review_tag)
    click_on "Edit this review tag", match: :first

    fill_in "Review", with: @review_tag.review_id
    fill_in "Tag", with: @review_tag.tag_id
    click_on "Update Review tag"

    assert_text "Review tag was successfully updated"
    click_on "Back"
  end

  test "should destroy Review tag" do
    visit review_tag_url(@review_tag)
    click_on "Destroy this review tag", match: :first

    assert_text "Review tag was successfully destroyed"
  end
end
