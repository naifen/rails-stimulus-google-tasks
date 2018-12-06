require "rails_helper"

WAIT_DURATION = 2

RSpec.feature "User authentication", :type => :feature do
  let(:user) { create(:user, active: true, approved: true, confirmed: true) }
  let(:rand_user) { build(:rand_user) }

  scenario "User tries to login with username and password" do
    visit "/login"

    ensure_elements_before_login_on page

    within("#login-form") do
      fill_in "login-form-username", :with => user.username
      fill_in "login-form-password", :with => user.password
      check   "login-form-remember"
      click_button "Log in"
    end

    ensure_elements_after_login_on page
    ensure_already_login_warning_on page

    click_link "Log out"
    expect(page).to have_selector(".is-info", :text => "Log out successfully, see you soon!")
  end

  scenario "User tries to login with email and password" do
    visit "/login"

    ensure_elements_before_login_on page

    within("#login-form") do
      fill_in "login-form-username", :with => user.email
      fill_in "login-form-password", :with => user.password
      check   "login-form-remember"
      click_button "Log in"
    end

    ensure_elements_after_login_on page
    ensure_already_login_warning_on page
  end

  scenario "User tries to login with phone number and password" do
    visit "/login"

    ensure_elements_before_login_on page

    within("#login-form") do
      fill_in "login-form-username", :with => user.phone_number
      fill_in "login-form-password", :with => user.password
      check   "login-form-remember"
      click_button "Log in"
    end

    ensure_elements_after_login_on page
    ensure_already_login_warning_on page
  end

  scenario "User tries to signup with username & email", js: true do
    visit "/signup"

    expect(page).to have_selector("a", :text => "Sign up") # Sign up button in nav

    expect(page).to have_selector("input[value='Next']")
    within("#step1form") do
      fill_in "step1form-username",      :with => rand_user.username
      fill_in "step1form-email",         :with => rand_user.email
      click_button "Next"
    end

    within("#signupform") do
      fill_in "signupform-password",      :with => rand_user.password
      fill_in "signupform-password-conf", :with => rand_user.password_confirmation
      sleep WAIT_DURATION # wait for submit button to be enabled by js
      click_button "Sign up"
    end

    # TODO: fix this error occured when js set to true
    # uninitialized constant Selenium::WebDriver::Error::ElementNotInteractableError
    # ------------------
    # --- Caused by: ---
    # Selenium::WebDriver::Error::StaleElementReferenceError:
    #   stale element reference: element is not attached to the page document

    # expect(page).not_to have_selector("a", :text => "Sign up")
    # expect(page).to have_selector("a", :text => "Log out")
    # expect(page).to have_selector("h1", :text => "Pages#home")
    # expect(page).to have_selector(".is-info", :text => "Sign up successfully!")

    # visit "/signup" # redirect if already signin
    # expect(page).to have_selector("a", :text => "Log out")
    # expect(page).to have_selector(".is-warning", :text => "Already logged in")

    # visit "/login"
    # expect(page).to have_selector(".is-warning", :text => "Already logged in")

    # click_link "Log out"
    # expect(page).to have_selector(".is-info", :text => "Log out successfully, see you soon!")
  end

  def ensure_elements_before_login_on(page)
    expect(page).to have_selector("a", :text => "Sign up")
    expect(page).not_to have_selector("a#account-icon")
  end

  def ensure_elements_after_login_on(page)
    expect(page).not_to have_selector("a", :text => "Sign up")
    expect(page).to have_selector("a", :text => "Log out")
    expect(page).to have_selector("div#app-main")
    expect(page).to have_selector("a#account-icon")
    expect(page).to have_selector(".is-info", :text => "Login successfully!")
  end

  def ensure_already_login_warning_on(page)
    visit "/signup" # redirect if already signin
    expect(page).to have_selector("a", :text => "Log out")
    expect(page).to have_selector(".is-warning", :text => "Already logged in")

    visit "/login"
    expect(page).to have_selector(".is-warning", :text => "Already logged in")
  end
end
