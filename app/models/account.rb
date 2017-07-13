class Account < ApplicationRecord
  default_scope { order(created_at: :asc) }

  has_many :accounts_apps
  has_many :apps, through: :accounts_apps

  validates :email, :password, :app_ids, presence: true
  validates :email, uniqueness: true

  enum status: %I[not_synhronized in_progress failed synhronized]

  def synhronize
    delay.synhronize!
  end

  private

  def synhronize!
    bot = AdUnitBot.new(self)
    bot.start_synchronization
  end
end
