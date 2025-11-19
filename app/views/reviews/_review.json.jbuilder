json.extract! review, :id, :title, :body, :rating, :user_id, :game_id, :created_at, :updated_at
json.url review_url(review, format: :json)
