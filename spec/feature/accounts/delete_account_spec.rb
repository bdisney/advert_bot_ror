require 'rails_helper'

feature 'Delete account', %q{
  In order to cancel my account
  As an user
  I want to be able delete my account
} do

  given(:app) { create(:app) }
  before { create(:account, app_ids: app.id) }

  scenario 'User deletes account' do
    visit accounts_path
    click_on('Destroy')

    expect(page).to_not have_content('test@test.com')
    expect(page).to_not have_content('123456')
  end
end