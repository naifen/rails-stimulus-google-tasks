# frozen_string_literal: true

require 'google/apis/tasks_v1'
require 'googleauth'
require 'googleauth/stores/redis_token_store'

class GoogleTasksService
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
  APPLICATION_NAME = 'Rails Stimulus Google Tasks'
  SCOPE = Google::Apis::TasksV1::AUTH_TASKS_READONLY
  ALREADY_AUTHORIZED = "Already authorized."
  CREDENTIALS_KEY_PREFIX = 'g-user-credentials-json:'
  AUTH_CODE_KEY_PREFIX = 'g-user-auth-code:'

  def initialize(credentials, username)
    @credentials = credentials
    @username = username
  end

  def get_auth_url
    credentials_hash = JSON.parse @credentials
    authorizer = create_authorizer_with(credentials_hash)
    credentials = authorizer.get_credentials(@username)
    return authorizer.get_authorization_url(base_url: OOB_URI) if credentials.nil?
    ALREADY_AUTHORIZED
  end

  # Store auth token in selected token store(eg, redis) and return it
  # @param [String] token
  # autorization token obtained from auth url generated from get_auth_url
  # @return [Google::Auth::UserRefreshCredentials]
  def get_and_store_credentials(token)
    credentials_hash = JSON.parse @credentials
    authorizer = create_authorizer_with(credentials_hash)
    credentials = authorizer.get_credentials(@username)
    if credentials.nil?
      # store credentials in redis with key like "g-user-token:@username"
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: @username, code: token, base_url: OOB_URI
      )
    end
    credentials
  end

  def get_tasklists(code)
    tasks_service = Google::Apis::TasksV1::TasksService.new
    tasks_service.client_options.application_name = APPLICATION_NAME
    tasks_service.authorization = get_and_store_credentials(code)

    response = tasks_service.list_tasklists(max_results: 10)
    response.items
  end

  # Create an instance of Google::Auth::UserAuthorizer with credentials hash
  # @param [Hash] credentials_hash
  # Google API credentials, example: {"installed":{"client_id":"...", "client_secret":"..."}}
  # @return [Google::Auth::UserAuthorizer]
  private def create_authorizer_with(credentials_hash)
    client_id = Google::Auth::ClientId.from_hash(credentials_hash)
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: $redis)
    Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  end
end
