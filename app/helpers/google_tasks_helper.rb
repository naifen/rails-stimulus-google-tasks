# frozen_string_literal: true

require 'googleauth/stores/redis_token_store'

module GoogleTasksHelper
  # Check if Google::Auth::UserRefreshCredentials is stored in redis
  # @param [String] username
  # @return [Boolean]
  def is_google_tasks_connected_for(username)
    prfix = Google::Auth::Stores::RedisTokenStore::DEFAULT_KEY_PREFIX
    google_user_token_string = $redis.get("#{prfix}#{username}")

    google_user_token_string.present? &&
      google_user_token_string.include?("refresh_token") &&
      google_user_token_string.include?("access_token") &&
      google_user_token_string.include?("expiration_time_millis")
  end
end
