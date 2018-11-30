# frozen_string_literal: true
#
# Steps to connect to Google Tasks API:
# 1, Enable the Google Tasks API, and download the credentials.json file.
# 2, Copy&paste everything in credentials.json to 1st form, and generate url
# 3, Retrive auth code from the url, paste in 2nd form and submit. Done!

class GoogleTasksController < ApplicationController
  before_action :authenticate_user!
  # TODO: auth Google Tasks API in other actions

  def generate_url
    credentials = google_tasks_auth_params[:credentials].to_s
    gtasks_service = GoogleTasksService.new(credentials, current_user.username)
    url = gtasks_service.get_auth_url
    js_res = url_js_response(is_authorized: url == "Already authorized.", url: url)

    # TODO show flash
    respond_to do |format|
      format.js { render js: js_res }
    end
  end

  def authorize
    credentials = google_tasks_auth_params[:credentials].to_s
    code = google_tasks_auth_params[:code].to_s
    gtasks_service = GoogleTasksService.new(credentials, current_user.username)
    stored_credentials = gtasks_service.get_and_store_credentials(code)
    js_res = "console.log('please auth!')"
    # Store credentials json and auth code in redis for later Google Tasks auth
    if stored_credentials.present?
      $redis.set(
        "#{GoogleTasksService::CREDENTIALS_KEY_PREFIX}#{current_user.username}",
        credentials
      )
      $redis.set(
        "#{GoogleTasksService::AUTH_CODE_KEY_PREFIX}#{current_user.username}",
        code
      )
      js_res = "console.log('Google Tasks API uccessfully authorized')"
    end

    # TODO show flash
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
      params.require(:google_tasks_auth).permit(:credentials, :code)
    end

    def url_js_response(is_authorized: false, url: "")
      res = "const target=document.querySelector('#auth-url');"
      if is_authorized
        res += "target.textContent='#{url}';"
      else
        res += "target.href='#{url}';target.textContent='#{url}';"
      end
    end
end
