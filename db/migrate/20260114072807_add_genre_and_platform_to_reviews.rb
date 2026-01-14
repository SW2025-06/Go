class AddGenreAndPlatformToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :genre, :string
    add_column :reviews, :platform, :string
  end
end
