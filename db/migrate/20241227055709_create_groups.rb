class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.timestamps
      t.index %i[name], unique: true
    end
  end
end
