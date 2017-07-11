class AddBlockTypesToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :block_types, :string, array: true, default: []
  end
end
