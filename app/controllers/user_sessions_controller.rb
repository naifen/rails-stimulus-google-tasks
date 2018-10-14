# frozen_string_literal: true

class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  # TODO: return errors if not successfully login
  # TODO: remember me
  def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      redirect_back_or root_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:username, :password, :remember_me)
  end
end

