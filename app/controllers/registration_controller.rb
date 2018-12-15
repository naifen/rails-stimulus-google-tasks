# frozen_string_literal: true
#
class RegistrationController < ApplicationController
  before_action :ensure_not_already_login

  def new
  end

  def create
    @user = User.new(signup_params)

    respond_to do |format|
      if @user.save
        if UserSession.create @user # login user after signup
          format.html { redirect_to root_path,
                        notice: 'Sign up successfully! You are now login.' }
        else
          format.html {
            redirect_to login_path,
            alert: "A problem's occured while login, please login manually."
          }
        end
      else
        error_res = {
          is_display_notification: true,
          notification: {
            content: @user.errors.full_messages.join(", ") || "Something went wrong",
            type: "danger"
          }
        }
        format.json { render json: error_res.to_json }
      end
    end
  end

  private

    def signup_params
      params.require(:signup).permit(:email, :username, :phone_number, :password, :password_confirmation)
    end
end
