class KeysForGroup < ActiveRecord::Migration[8.0]
  def change
    Followership.delete_all
    Group.delete_all
    add_column :groups, :private_key, :text, null: false
    add_column :groups, :public_key, :text, null: false
  end
end
