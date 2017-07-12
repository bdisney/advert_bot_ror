class AddStatusColumnToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :status, :integer, default: 0
  end
end
