class GoogleTasksController < ApplicationController
  # TODO: figure out how to create an authorizer in other actions without params
  # before_action :auth_google_tasks, only: :index
  before_action :authenticate_user!

  # Steps:
  # 1, enable google tasks API by creating new google project or using existing one
  # 2, submit client_id and secret to get a auth url
  # 3, click generated url and get auth token, submit auth token, done

  def generate_url
    credentials = google_tasks_auth_params[:credentials].to_s
    google_tasks_service = GoogleTasksService.new(credentials,
                                                   current_user.username)
    # url for retriving auth token which is used to store credential in redis
    url = google_tasks_service.get_auth_url
    respond_to do |format|
      format.js do
        render js: "const target=document.querySelector('#auth-url');target.href='" +
                   "#{url}';target.textContent='#{url}';" +
                   "const cred=document.querySelector('#token-form-credentials');" +
                   "cred.value='#{credentials}';"
      end
    end
  end

  def authorize
    # TODO: use stimulus to fill the text filed of credentials
    credentials = google_tasks_auth_params[:credentials].to_s
    token = google_tasks_auth_params[:token].to_s
    google_tasks_service = GoogleTasksService.new(credentials,
                                                  current_user.username)

    stored_credentials = google_tasks_service.get_and_store_credentials(token)
    respond_to do |format|
      format.js do
        render js: "console.log(#{stored_credentials}.to_s)"
      end
    end
  end

  def index
    # @task_lists = google_tasks_service.get_tasklists(token)
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
      params.require(:google_tasks_auth).permit(:credentials, :token)
    end
end
