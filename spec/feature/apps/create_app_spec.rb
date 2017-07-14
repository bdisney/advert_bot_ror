require 'rails_helper'

feature 'Create app', %q{
  In order to get access to manage ad_unt_bot
  As a user
  I want to be able add app
} do


  scenario 'User creates app with valid data' do
    visit new_app_path

    fill_in 'Name', with: 'Test_App'
    fill_in 'Url', with: 'test-test.com'
    fill_in 'Platform id', with: '142'
    find('#app_block_types').find("option[value='standard']").select_option

    click_on('Create App')


    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Application was created.')
    expect(page).to have_content('Test_App')
    expect(page).to have_content('test-test.com')
    expect(page).to have_content('142')
    expect(page).to have_content('standard')
  end

  scenario 'User creates app with invalid data' do
    visit new_app_path

    fill_in 'Name', with: ''
    fill_in 'Url', with: ''
    fill_in 'Platform id', with: '142'
    find('#app_block_types').find("option[value='standard']").select_option

    click_on('Create App')

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Name can&#39;t be blank")
    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Url can&#39;t be blank")
  end
end
