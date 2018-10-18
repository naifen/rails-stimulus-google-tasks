# frozen_string_literal: true
#
class RegistrationController < ApplicationController
  before_action :ensure_not_already_login

  def new
  end

  # TODO: error msgs from ajax, instead of redirect
  # TODO: make sure email/phone is nil if blank w/ Stimulus(hide or show)
  # like twitter signup
  # TODO show check/cross icon for input field(eg, username taken, etc)
  def create
    @user = User.new(signup_params)

    respond_to do |format|
      if @user.save
        # login user after signup
        # TODO stimulus close notification
        if UserSession.create @user
          format.html { redirect_to root_path, notice: 'Sign up successfully!' }
        else
          format.html {
            redirect_to signup_path,
            alert: "A problem's occured while signing up, please try again."
          }
        end
      else
        format.html {
          redirect_to signup_path,
          alert: "A problem's occured while signing up, please try again."
        }
      end
    end
  end

  private

    def signup_params
      params.require(:signup).permit(:email, :username, :phone_number, :password, :password_confirmation)
    end
end
