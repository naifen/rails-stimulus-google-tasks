class RegistrationController < ApplicationController
  before_action :ensure_not_already_login

  def new
  end

  # TODO: better form icons and error msgs
  def create
    # TODO: make sure email/phone is nil if blank
    @user = User.new(signup_params)

    respond_to do |format|
      if @user.save
        # login user after signup
        # TODO show notice in layout
        if UserSession.create @user
          format.html { redirect_to root_path, notice: 'Successfully registered.' }
        end
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def signup_params
      params.require(:signup).permit(:email, :username, :phone_number, :password, :password_confirmation)
    end
end
