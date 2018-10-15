require "rails_helper"

RSpec.feature "User authentication", :type => :feature do
  let(:user) { create(:user, active: true, approved: true, confirmed: true) }
  let(:rand_user) { build(:rand_user) }

  scenario "User tries to login" do
    visit "/login"

    expect(page).to have_selector("a", :text => "Sign up")

    within("#login-form") do
      fill_in "login-form-username", :with => user.username
      fill_in "login-form-password", :with => user.password
      check   "login-form-remember"
      click_button "Log in"
    end

    expect(page).not_to have_selector("a", :text => "Sign up")
    expect(page).to have_selector("a", :text => "Log out")
    expect(page).to have_selector("h1", :text => "Pages#home")
    expect(page).to have_selector(".is-info", :text => "Login successfully!")

    click_link "Log out"
  end

  scenario "User tries to signup" do
    visit "/signup"

    expect(page).to have_selector("a", :text => "Sign up")

    within("#signup-form") do
      fill_in "signup-form-username",      :with => rand_user.username
      fill_in "signup-form-email",         :with => rand_user.email
      fill_in "signup-form-password",      :with => rand_user.password
      fill_in "signup-form-password-conf", :with => rand_user.password
      click_button "Sign up"
    end

    expect(page).not_to have_selector("a", :text => "Sign up")
    expect(page).to have_selector("a", :text => "Log out")
    expect(page).to have_selector("h1", :text => "Pages#home")
    expect(page).to have_selector(".is-info", :text => "Sign up successfully!")

    click_link "Log out"
    expect(page).to have_selector(".is-info", :text => "Log out successfully, see you soon!")
  end
end
