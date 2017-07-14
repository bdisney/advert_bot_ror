require 'rails_helper'

feature 'Delete app', %q{
  In order to cancel my app
  As an user
  I want to be able delete my app
} do

  given(:app) { create(:app) }

  scenario 'User deletes app' do
    visit app_path(app)
    click_on('Destroy')

    expect(current_path).to eq apps_path
    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'App was destroyed.')
    expect(page).to_not have_content(app.name)
    expect(page).to_not have_content(app.url)
    expect(page).to_not have_content(app.platform_id)
    expect(page).to_not have_content(app.block_types)
  end
end
