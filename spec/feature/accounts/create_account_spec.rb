require 'rails_helper'

feature 'Create account', %q{
  In order to get access to manage ad_unt_bot
  As a user
  I want to be able add account
} do

  before { create(:app) }

  scenario 'User creates account with valid data' do
    visit new_account_path

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    select 'TestApp', from: 'account[app_ids][]'
    click_on('Create Account')

    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Account was created.')
    expect(page).to have_content('test@test.com')
    expect(page).to have_content('123456')
    expect(page).to have_content('TestApp')
  end

  scenario 'User creates account with invalid data' do
    visit new_account_path

    fill_in 'Email', with: ''
    fill_in 'Password', with: ''

    click_on('Create Account')

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Email can&#39;t be blank")
    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Password can&#39;t be blank")
    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "App_ids can&#39;t be blank")

  end
end
