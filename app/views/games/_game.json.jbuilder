json.extract! game, :id, :title, :platform, :genre, :release_date, :created_at, :updated_at
json.url game_url(game, format: :json)
