class CreateAccountsApps < ActiveRecord::Migration[5.0]
  def change
    create_join_table :accounts, :apps do |t|
      t.index :account_id
      t.index :app_id

      t.timestamps
    end
  end
end
