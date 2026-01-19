class CreateReviewRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :review_ratings do |t|
      t.references :review, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.integer :helpfulness, null: false, default: 0
      t.integer :want_to_play, null: false, default: 0
      t.integer :recommend_to_friend, null: false, default: 0

      t.timestamps
    end

    add_index :review_ratings, [:review_id, :user_id], unique: true
  end
end
