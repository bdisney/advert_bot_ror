class App < ApplicationRecord
  has_many :accounts_apps
  has_many :accounts, through: :accounts_apps
  validates :name, :url, :platform_id, :block_types, presence: true

  AD_UNIT_TYPE = { standard: 'Standard', medium: 'Medium', leaderboard: 'Leaderboard' }.freeze
end
