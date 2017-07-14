require 'rails_helper'

feature 'Edit app', %q{
  In order to correct my app
  As a user
  I want to be able to edit app
} do

  scenario 'User edit app' do
    app = create(:app)
    visit app_path(app)
    click_on('Edit')

    expect(current_path).to eq edit_app_path(app)
    fill_in 'Name', with: 'NewTestApp'
    fill_in 'Url',  with: 'new-test-app.com'
    fill_in 'Platform id', with: '777'

    click_on('Update App')
    expect(current_path).to eq apps_path
    expect(page).to have_content('NewTestApp')
    expect(page).to have_content('new-test-app.com')
    expect(page).to have_content('777')
  end
end
