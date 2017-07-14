require 'rails_helper'

feature 'Edit app', %q{
  In order to correct my account
  As a user
  I want to be able to edit account
} do

  given(:app) { create(:app) }
  given(:account) { create(:account, app_ids: app.id) }

  scenario 'User tries edit account with valid data' do
    visit account_path(account)
    click_on('Edit')

    expect(current_path).to eq edit_account_path(account)
    fill_in 'Email', with: 'newemail@test.com'
    fill_in 'Password',  with: '12345678'
    select 'TestApp', from: 'account[app_ids][]'

    click_on('Update Account')
    expect(current_path).to eq accounts_path
    expect(page).to have_content('newemail@test.com')
    expect(page).to have_content('TestApp')
  end
end