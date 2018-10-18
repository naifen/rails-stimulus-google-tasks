require 'rails_helper'

RSpec.describe "user_sessions requests", :type => :request do
  let(:user) { create(:user) }

  it "redirect after fill in username, password and successful login" do
    get "/login"
    assert_select "#login-form" do
      assert_select "input[name=?]", "user_session[username]"
      assert_select "input[name=?]", "user_session[password]"
      assert_select "input[type=?]", "submit"
    end

    session_params = {
      :params => {
        :user_session => {
          :username => user.username,
          :password => user.password
        }
      }
    }

    post "/user_sessions", session_params
    expect(response).to redirect_to(root_path)

    get "/login"
    expect(response).to redirect_to(root_path)

    delete "/logout"
    expect(response).to redirect_to(root_path)
  end

  it "redirect after fill in email, password and successful login" do
    get "/"

    session_params = {
      :params => {
        :user_session => {
          :username => user.email,
          :password => user.password
        }
      }
    }

    post "/user_sessions", session_params
    expect(response).to redirect_to(root_path)
  end

  it "redirect after fill in phone number, password and successful login" do
    get "/"

    session_params = {
      :params => {
        :user_session => {
          :username => user.phone_number,
          :password => user.password
        }
      }
    }

    post "/user_sessions", session_params
    expect(response).to redirect_to(root_path)
  end
end
