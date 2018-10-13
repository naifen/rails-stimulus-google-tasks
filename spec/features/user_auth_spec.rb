require "rails_helper"

RSpec.feature "User authentication", :type => :feature do
  let(:user) { create(:user, active: true, approved: true, confirmed: true) }

  scenario "User tries to login" do
    visit "/login"

    within("#login-form") do
      fill_in "login-form-username", :with => user.username
      fill_in "login-form-password", :with => user.password
      click_button "Log in"
    end

    expect(page).to have_selector("a", :text => "Log out")
  end
end
