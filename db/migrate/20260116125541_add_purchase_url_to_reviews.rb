class AddPurchaseUrlToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :purchase_url, :string
  end
end
