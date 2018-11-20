# frozen_string_literal: true

require "turbolinks/redirection"

class ApplicationController < ActionController::Base
  include Pundit
  include Turbolinks::Redirection # add this line b/c turbolinks require: false

  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized_action

  # Pundit will call the current_user method to retrieve what to send into user
  # argument in policy. https://github.com/varvet/pundit#policies
  def current_user
    helpers.current_user
  end

  # authlogic needs this CSRF protection patch, more details:
  # https://github.com/binarylogic/authlogic#2d-csrf-protection
  protected

    def handle_unverified_request
      # raise an exception
      fail ActionController::InvalidAuthenticityToken
      # or destroy session, redirect
      if current_user_session
        current_user_session.destroy
      end
      redirect_to root_path, error: 'An error has occured, please try again.'
    end

  private

    def authenticate_user!
      unless helpers.current_user
        store_location
        redirect_to login_path, alert: "Please log in to access this page."
        return false
      end
    end

    def ensure_not_already_login
      if helpers.current_user
        redirect_back fallback_location: root_path, alert: "Already logged in."
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

    def handle_unauthorized_action
      redirect_back(fallback_location: request.referrer || root_path,
                    alert: "You are not authorized to perform this action!")
      return false
    end
end
