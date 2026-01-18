class MakeGameIdNullableOnReviews < ActiveRecord::Migration[8.0]
  def change
    change_column_null :reviews, :game_id, true
  end
end
