class Account < ApplicationRecord
  has_many :accounts_apps
  has_many :apps, through: :accounts_apps

  validates :email, :password, presence: true

  def synhronize
    bot = AdUnitBot.new(self)
    bot.start_synchronization
  end
end
