require 'rails_helper'

feature 'View account log', %q{
  In order to view synhronization info
  As a user
  I want to be able to view account synhronisation logs
} do

  given(:app) { create(:app) }

  scenario 'User view account log' do
    account = create(:account, app_ids: app.id )
    visit accounts_path
    click_on('Log')

    expect(current_path).to eq show_log_account_path(account)
    expect(page).to have_content("Log for #{account.email}")
  end
end