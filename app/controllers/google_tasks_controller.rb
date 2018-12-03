# frozen_string_literal: true
#
# Steps to connect to Google Tasks API:
# 1, Enable the Google Tasks API, and download the credentials.json file.
# 2, Copy&paste everything in credentials.json to 1st form, and generate url
# 3, Retrive auth code from the url, paste in 2nd form and submit. Done!

class GoogleTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_connected, only: [:generate_url, :authorize]
  before_action :ensure_connected, only: [:index, :create, :update, :destroy]

  def generate_url
    credentials = google_tasks_auth_params[:credentials].to_s
    gtasks_service = GoogleTasksService.new(credentials, current_user.username)
    url = gtasks_service.get_auth_url
    js_res = url_js_res(is_authorized: url == GoogleTasksService::ALREADY_AUTHORIZED,
                        url: url)

    # TODO show flash
    respond_to do |format|
      format.js { render js: js_res }
    end
  end

  def authorize
    credentials = google_tasks_auth_params[:credentials].to_s
    code = google_tasks_auth_params[:auth_code].to_s
    username = current_user.username
    gtasks_service = GoogleTasksService.new(credentials, username)
    stored_credentials = gtasks_service.get_and_store_credentials(code)
    js_res = "console.log('please auth!')"
    # Store credentials json and auth code in redis for later Google Tasks auth
    if stored_credentials.present?
      $redis.set("#{GoogleTasksService::CREDENTIALS_KEY_PREFIX}#{username}",
                 credentials)
      $redis.set("#{GoogleTasksService::AUTH_CODE_KEY_PREFIX}#{username}",
                 code)
      js_res = "console.log('Google Tasks API uccessfully authorized')"
    end

    # TODO redirect to google tasks path for success, ajax flash for fail
    respond_to do |format|
      format.js do
        render js: js_res
      end
    end
  end

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def google_tasks_auth_params
      params.require(:google_tasks_auth).permit(:credentials, :auth_code)
    end

    def url_js_res(is_authorized: false, url: "")
      res = "const target=document.querySelector('#auth-url');"
      if is_authorized
        res += "target.textContent='#{url}';"
      else
        res += "target.href='#{url}';target.textContent='#{url}';"
      end
    end

    def ensure_not_connected
      if helpers.is_google_tasks_connected_for(current_user.username)
        redirect_to google_tasks_path,
                    notice: "Google Tasks Service already connected."
        return false
      end
    end

    def ensure_connected
      unless helpers.is_google_tasks_connected_for(current_user.username)
        redirect_to root_path,
                    notice: "Please connect your Google Tasks Service first."
        return false
      end
    end
end
