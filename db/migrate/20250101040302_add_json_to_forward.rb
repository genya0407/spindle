class AddJsonToForward < ActiveRecord::Migration[8.0]
  def up
    Forward.delete_all
    add_column :forwards, :json, :json, null: false
  end
end
