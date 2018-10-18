# frozen_string_literal: true

class UserSessionsController < ApplicationController
  before_action :ensure_not_already_login, only: [:new, :create]

  def new
    @user_session = UserSession.new
  end

  # TODO: error msgs from ajax, instead of redirect, could be this:
  # <h2><%= pluralize(@user_session.errors.count, "error") %> prohibited:</h2>
  # <ul>
    # <% @user_session.errors.full_messages.each do |msg| %>
      # <li><%= msg %></li>
    # <% end %>
  # </ul>
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
    if helpers.current_user_session.destroy
      redirect_to root_path, notice: "Log out successfully, see you soon!"
    end
  end

  private

  def user_session_params
    params.require(:user_session).permit(:username, :password, :remember_me)
  end
end

