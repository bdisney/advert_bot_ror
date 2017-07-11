class AddPlatformIdToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :platform_id, :integer
  end
end
