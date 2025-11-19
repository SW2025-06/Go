json.extract! review_tag, :id, :review_id, :tag_id, :created_at, :updated_at
json.url review_tag_url(review_tag, format: :json)
