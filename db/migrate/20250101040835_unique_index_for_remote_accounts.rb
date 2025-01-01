class UniqueIndexForRemoteAccounts < ActiveRecord::Migration[8.0]
  def change
    remove_index :remote_accounts, :uri
    add_index :remote_accounts, :uri, unique: true
  end
end
