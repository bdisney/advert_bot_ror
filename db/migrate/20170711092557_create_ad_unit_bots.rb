class CreateAdUnitBots < ActiveRecord::Migration[5.0]
  def change
    create_table :ad_unit_bots do |t|
      t.string :target_url
    end
  end
end
