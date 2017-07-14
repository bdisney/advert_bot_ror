require 'rails_helper'

feature 'Display list of accounts', %q{
  In order to watch list of my accounts
  As a user
  I want to be able view accounts list
} do

  given(:app) { create(:app) }
  given!(:accounts) { create_list(:account, 3, app_ids: app.id) }

  scenario 'User views the list of accounts' do
    visit accounts_path

    expect(page).to have_selector '#accounts-list'

    within '#accounts-list' do
      accounts.each do |acc|
        expect(page).to have_link acc.email
        expect(page).to have_link('Show')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Destroy')
      end
    end
  end
end