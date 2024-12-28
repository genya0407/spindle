class AddInboxToAccount < ActiveRecord::Migration[8.0]
  def change
    RemoteAccount.delete_all
    Followership.delete_all
    add_column :remote_accounts, :inbox, :text, null: false
  end
end
