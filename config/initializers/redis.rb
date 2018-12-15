# frozen_string_literal: true

require "redis"

REDIS_URL = "redis://localhost:6379/1"

$redis = Redis.new(
  url: Rails.application.credentials[Rails.env.to_sym][:redis][:url] || REDIS_URL,
  driver: :hiredis,
  db: 0
)
