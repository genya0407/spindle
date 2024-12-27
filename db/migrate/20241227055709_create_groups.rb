class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.timestamps
      t.index %i[name]
    end
  end
end
