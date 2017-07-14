require 'rails_helper'

feature 'View account', %q{
  In order to solve my task
  As a user
  I want to be able to view account
} do

  given(:app) { create(:app) }

  scenario 'View account' do
    account = create(:account, email: 'test@test.com', app_ids: app.id )
    visit accounts_path
    click_on('Show')

    expect(current_path).to eq account_path(account)
    expect(page).to have_content(account.email)
    expect(page).to have_content(account.password)
    expect(page).to have_content(app.name)
  end
end