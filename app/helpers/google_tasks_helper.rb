# frozen_string_literal: true

require 'googleauth/stores/redis_token_store'

module GoogleTasksHelper
  # Check if Google::Auth::UserRefreshCredentials and credential json and
  # auth code is stored in redis
  # @param [String] username
  # @return [Boolean]
  def is_google_tasks_connected_for(username)
    prefix = Google::Auth::Stores::RedisTokenStore::DEFAULT_KEY_PREFIX
    cred_prefix = GoogleTasksService::CREDENTIALS_KEY_PREFIX
    code_prefix = GoogleTasksService::AUTH_CODE_KEY_PREFIX
    google_user_token_string = $redis.get("#{prefix}#{username}")
    google_user_cred_string = $redis.get("#{cred_prefix}#{username}")
    google_user_code_string = $redis.get("#{code_prefix}#{username}")

    google_user_token_string.present? &&
      google_user_token_string.include?("refresh_token") &&
      google_user_token_string.include?("access_token") &&
      google_user_token_string.include?("expiration_time_millis") &&
      google_user_cred_string.present? && google_user_code_string.present?
  end
end
