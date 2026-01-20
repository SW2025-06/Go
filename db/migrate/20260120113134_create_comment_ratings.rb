class CreateCommentRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :comment_ratings do |t|
      t.references :comment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.integer :stars, null: false, default: 0
      t.integer :helpfulness, null: false, default: 0

      t.timestamps
    end

    add_index :comment_ratings, [:comment_id, :user_id], unique: true
  end
end
