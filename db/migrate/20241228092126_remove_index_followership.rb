class RemoveIndexFollowership < ActiveRecord::Migration[8.0]
  def up
    remove_index :followerships, name: 'index_followerships_on_group_id'
    remove_index :followerships, name: 'index_followerships_on_remote_account_id'
  end
end
