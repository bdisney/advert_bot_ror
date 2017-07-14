require 'rails_helper'

feature 'View app', %q{
  In order to solve my task
  As a user
  I want to be able to view app
} do

  scenario 'View app' do
    app = create(:app)
    visit apps_path
    click_on('Show')

    expect(current_path).to eq app_path(app)
    expect(page).to have_content('TestApp')
    expect(page).to have_content('test-app.com')
    expect(page).to_not have_content('142')
    expect(page).to have_content('standard')
  end
end
