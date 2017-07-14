require 'rails_helper'

feature 'Edit app', %q{
  In order to correct my app
  As a user
  I want to be able to edit app
} do

  given(:app) { create(:app) }

  scenario 'User update app with valid data' do
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

  scenario 'User update app with invalid data' do
    visit app_path(app)
    click_on('Edit')

    expect(current_path).to eq edit_app_path(app)

    fill_in 'Name', with: ''
    fill_in 'Url',  with: ''
    fill_in 'Platform id', with: '666'

    click_on('Update App')

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Name can&#39;t be blank")
    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Url can&#39;t be blank")
  end
end
