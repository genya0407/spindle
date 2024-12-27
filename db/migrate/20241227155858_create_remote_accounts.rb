class CreateRemoteAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :remote_accounts do |t|
      t.string :uri, null: false
      t.string :name, null: false
      t.string :domain, null: false
      t.string :public_key, null: false
      t.timestamps
      t.index %i[domain name], unique: true
      t.index %i[uri]
    end
  end
end
