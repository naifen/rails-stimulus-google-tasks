# frozen_string_literal: true

require "turbolinks/redirection"

class ApplicationController < ActionController::Base
  include Turbolinks::Redirection # add this line b/c turbolinks require: false

  helper_method :current_user_session, :current_user

  protected

    def handle_unverified_request
      # raise an exception
      fail ActionController::InvalidAuthenticityToken
      # or destroy session, redirect
      if current_user_session
        current_user_session.destroy
      end
      redirect_to root_path
    end

  # TODO refactor to helpers
  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def authenticate_user!
      unless current_user
        store_location
        # flash[:notice] = "You must be logged in to access this page"
        redirect_to sign_in_path
        return false
      end
    end

    def store_location
      session[:forwarding_url] = request.original_url if request.get?
    end

    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end
end
