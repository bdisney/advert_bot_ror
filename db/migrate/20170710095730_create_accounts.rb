class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
