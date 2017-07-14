require 'rails_helper'

feature 'Display list of apps', %q{
  In order to watch list of my apps
  As a user i want to be able
  I want to be able view app list
} do

  scenario 'User views the list of apps' do
    create_list(:app, 3)

    visit apps_path

    expect(page).to have_content('TestApp', count: 3)
    expect(page).to have_content('test-app.com', count: 3)
    expect(page).to have_content('42', count: 3)
    expect(page).to have_content('standard', count: 3)
  end
end
