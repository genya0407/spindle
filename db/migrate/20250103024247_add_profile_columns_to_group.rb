class AddProfileColumnsToGroup < ActiveRecord::Migration[8.0]
  def change
    Group.delete_all
    add_column :groups, :icon_url, :text, null: false
    add_column :groups, :summary, :text, null: false
  end
end
