require 'rails_helper'

RSpec.describe "user_sessions requests", :type => :request do
  let(:user) { create(:user, active: true, approved: true, confirmed: true) }

  it "displays the user's username after successful login" do
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

    delete "/logout"
    expect(response).to redirect_to(root_path)
  end
end
