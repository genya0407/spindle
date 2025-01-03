class RemoveIconUrlFromGroup < ActiveRecord::Migration[8.0]
  def change
    remove_column :groups, :icon_url
  end
end
