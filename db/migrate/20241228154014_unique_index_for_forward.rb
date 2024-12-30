class UniqueIndexForForward < ActiveRecord::Migration[8.0]
  def change
    add_index :forwards, %i[group_id original_status_uri], unique: true
  end
end
