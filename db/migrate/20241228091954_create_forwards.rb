class CreateForwards < ActiveRecord::Migration[8.0]
  def change
    create_table :forwards do |t|
      t.references :group
      t.text :original_status_uri, null: false
      t.timestamps
    end
  end
end
