class AllowNullEmailAndRemoveEmailUniqueIndex < ActiveRecord::Migration[7.0]
  def up
    # index があれば削除（存在チェックつき）
    if index_exists?(:users, :email, unique: true)
      remove_index :users, column: :email
      say "Removed unique index on users.email"
    else
      say "No unique index on users.email found — skipping remove_index"
    end

    # email を NULL 許可に変更（既に nullable なら何もしない）
    if column_exists?(:users, :email) && !column_nullable?(:users, :email)
      change_column_null :users, :email, true
      say "Changed users.email to allow NULL"
    else
      say "users.email is already nullable or does not exist — skipping change_column_null"
    end
  end

  def down
    # 離脱しやすくするため、ダウンサイドは慎重に
    if column_exists?(:users, :email)
      change_column_null :users, :email, false
      say "Changed users.email to NOT NULL (down)"
    end

    unless index_exists?(:users, :email, unique: true)
      add_index :users, :email, unique: true
      say "Re-added unique index on users.email (down)"
    end
  end

  private

  # SQLite 対応：Rails に column_nullable? ヘルパがないと落ちるので自前実装
  def column_nullable?(table, column)
    col = ActiveRecord::Base.connection.columns(table).find { |c| c.name.to_s == column.to_s }
    return true if col.nil?
    col.null
  end
end