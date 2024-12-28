class CreateFollowerships < ActiveRecord::Migration[8.0]
  def change
    create_table :followerships do |t|
      t.references :group
      t.references :remote_account
      t.index [ :group_id, :remote_account_id ], unique: true
      t.timestamps
    end
  end
end
