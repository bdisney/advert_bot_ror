class Account < ApplicationRecord
  has_many :accounts_apps
  has_many :apps, through: :accounts_apps

  validates :email, :password, presence: true
end
