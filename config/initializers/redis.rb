# frozen_string_literal: true

require "redis"

# TODO: create Redis instance with yaml config file, eg:
# redis_config = Rails.application.config_for(:redis) # look for config/redis.yml
$redis = Redis.new(driver: :hiredis)
