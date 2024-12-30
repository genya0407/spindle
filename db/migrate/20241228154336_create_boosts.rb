class CreateBoosts < ActiveRecord::Migration[8.0]
  def change
    create_table :boosts do |t|
      t.references :group
      t.text :original_status_uri, null: false
      t.timestamps
      t.index %i[group_id original_status_uri], unique: true
    end
  end
end
