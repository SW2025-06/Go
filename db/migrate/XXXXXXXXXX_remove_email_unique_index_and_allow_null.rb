class RemoveEmailUniqueIndexAndAllowNull < ActiveRecord::Migration[7.0]
  def change
    # index が standard name の場合
    if index_exists?(:users, :email, unique: true)
      remove_index :users, column: :email
    end

    # email を NULL 許可に（既に nullableなら問題なし）
    change_column_null :users, :email, true
  end
end