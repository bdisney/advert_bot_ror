class Account < ApplicationRecord
  has_many :accounts_apps
  has_many :apps, through: :accounts_apps

  validates :email, :password, presence: true

  enum status: %I[not_synhronized in_progress failed synhronized]

  def synhronize
    delay.synhronize!
  end

  def synhronize!
    bot = AdUnitBot.new(self)
    bot.start_synchronization
  end
end
