class AddColumnToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    remove_index :users, :username if index_exists?(:users, :username)
  end
end
