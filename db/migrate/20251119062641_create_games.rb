class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :title
      t.string :platform
      t.string :genre
      t.date :release_date

      t.timestamps
    end
  end
end
