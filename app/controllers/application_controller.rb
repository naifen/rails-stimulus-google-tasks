# frozen_string_literal: true

require "turbolinks/redirection"

class ApplicationController < ActionController::Base
  include Turbolinks::Redirection # add this line b/c turbolinks require: false
end
