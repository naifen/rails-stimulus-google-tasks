# frozen_string_literal: true

class UserSession < Authlogic::Session::Base
  # tell authlogic to find by username, email or phone_number
  # this way even with <%= f.text_field :username %> in signin form, user can
  # still login with either username, email or phone number
  # https://github.com/binarylogic/authlogic/blob/master/lib/authlogic/session/password.rb#L20
  find_by_login_method :find_by_username_email_or_phone
end

