# frozen_string_literal: true

class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  # TODO: error msgs from ajax, instead of redirect
  def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      flash[:notice] = "Login successfully!"
      redirect_back_or root_path
    else
      # flash.now[:alert] = "..."
      # render :action => :new # or format.html { render :new } with respond_to
      redirect_to login_path, alert: "A problem's occured while logging in, please try again."
    end
  end

  def destroy
    if current_user_session.destroy
      redirect_to root_path, notice: "Log out successfully, see you soon!"
    end
  end

  private

  def user_session_params
    params.require(:user_session).permit(:username, :password, :remember_me)
  end
end

