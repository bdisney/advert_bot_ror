class App < ApplicationRecord
  has_many :accounts_apps
  has_many :accounts, through: :accounts_apps
  validates :name, :url, presence: true
end
