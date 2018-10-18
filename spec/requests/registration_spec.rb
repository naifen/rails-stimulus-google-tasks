require 'rails_helper'

RSpec.describe "registration requests", :type => :request do
  let(:user) { build(:user) }

  it "displays the user's username after successful login" do
    get "/signup"
    assert_select "#signup-form" do
      assert_select "input[name=?]", "signup[username]"
      assert_select "input[name=?]", "signup[email]"
      assert_select "input[name=?]", "signup[phone_number]"
      assert_select "input[name=?]", "signup[password]"
      assert_select "input[name=?]", "signup[password_confirmation]"
      assert_select "input[type=?]", "submit"
    end

    signup_params = {
      :params => {
        :signup => {
          :username => user.username,
          :email => user.email,
          :phone_number => user.phone_number,
          :password => user.password,
          :password_confirmation => user.password_confirmation
        }
      }
    }

    post "/signup", signup_params
    expect(response).to redirect_to(root_path)

    get "/login"
    expect(response).to redirect_to(root_path)

    delete "/logout"
    expect(response).to redirect_to(root_path)
  end
end
