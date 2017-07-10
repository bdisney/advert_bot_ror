class AccountsApp < ApplicationRecord
  belongs_to :account
  belongs_to :app
end
