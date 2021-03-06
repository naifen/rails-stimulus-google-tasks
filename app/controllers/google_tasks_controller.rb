# frozen_string_literal: true
#
# Steps to connect to Google Tasks API:
# 1, Enable the Google Tasks API, and download the credentials.json file.
# 2, Copy&paste everything in credentials.json to 1st form, and generate url
# 3, Retrive auth code from the url, paste in 2nd form and submit. Done!

class GoogleTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_not_connected, only: [:generate_url, :authorize]
  before_action :ensure_connected, except: [:generate_url, :authorize]

  def generate_url
    credentials = google_tasks_auth_params[:credentials].to_s
    gtasks_service = GoogleTasksService.new(credentials, current_user.username)
    url = gtasks_service.get_auth_url
    res = {
      is_manipulate_dom: true,
      selector: "#auth-url",
      is_authorized: url == GoogleTasksService::ALREADY_AUTHORIZED,
      content: url
    }
    respond_to do |format|
      format.json { render json: res.to_json }
    end
  end

  def authorize
    error_res = {
      is_display_notification: true,
      notification: {
        content: "Something went wrong, please try again.",
        type: "danger"
      }
    } # Stimulus homeController listen to this response and display notification

    credentials = google_tasks_auth_params[:credentials].to_s
    code = google_tasks_auth_params[:auth_code].to_s
    username = current_user.username
    gtasks_service = GoogleTasksService.new(credentials, username)
    stored_credentials = gtasks_service.get_and_store_credentials(code)

    respond_to do |format|
      if stored_credentials.present?
        begin
          $redis.set("#{GoogleTasksService::CREDENTIALS_KEY_PREFIX}#{username}",
                    credentials)
          $redis.set("#{GoogleTasksService::AUTH_CODE_KEY_PREFIX}#{username}",
                    code)
        rescue StandardError => e
          puts e.inspect
          format.json { render json: error_res.to_json }
        else
          flash_content = "Google Tasks successfully connected."
          format.html { redirect_to google_tasks_path,
                                    flash: { success: flash_content } }
        end
      else
        format.json { render json: error_res.to_json }
      end
    end
  end

  def index
    app_name = 'Google Tasks Rails Stimulus'.freeze
    scope = Google::Apis::TasksV1::AUTH_TASKS_READONLY
    username = current_user.username

    credentials = $redis.get("#{GoogleTasksService::CREDENTIALS_KEY_PREFIX}#{username}")
    code = $redis.get("#{GoogleTasksService::AUTH_CODE_KEY_PREFIX}#{username}")
    gtasks_service = GoogleTasksService.new(credentials, username)
    stored_credentials = gtasks_service.get_and_store_credentials(code)
    service = Google::Apis::TasksV1::TasksService.new
    service.client_options.application_name = app_name
    service.authorization = stored_credentials

    @task_lists = service.list_tasklists(max_results: 10)
    @service = service # use &.each in view in case a tasklist is empty

    # TODO: CRUD individual task in a popup modal Collapsable
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

    def google_tasks_auth_params
      params.require(:google_tasks_auth).permit(:credentials, :auth_code)
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
