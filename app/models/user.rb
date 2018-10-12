# frozen_string_literal: true

class User < ApplicationRecord
  # TODO enable remember me in login
  acts_as_authentic do |c|
    c.validate_email_field = false
    c.validate_login_field = false
    c.validate_password_field = false
  end

  USERNAME_FORMAT              = 'A-Za-z0-9\-\_\.'
  ALLOW_USERNAME_FORMAT_REGEXP = /\A[#{USERNAME_FORMAT}]+\z/

  ALLOW_EMAIL_FORMAT_REGEXP = /
    \A
    [A-Z0-9_.&%+\-']+   # mailbox
    @
    (?:[A-Z0-9\-]+\.)+  # subdomains
    (?:[A-Z]{2,25})     # TLD
    \z
  /ix

  ALLOW_PHONE_FORMAT_REGEXP = /\A[0-9]+\z/

  validates :username,
    format: {
      with: ALLOW_USERNAME_FORMAT_REGEXP,
      message: 'only letters, numbers, -, _ are allowed.'
    },
    length: { in: 2..50 },
    presence: true,
    uniqueness: {
      case_sensitive: false,
      if: :username_changed?
    }

  validates :password,
    confirmation: { if: :require_password? },
    length: {
      minimum: 8,
      if: :require_password?
    }

  validates :password_confirmation,
    length: {
      minimum: 8,
      if: :require_password?
    }

  # custom validator
  validate :ensure_email_or_phone

  after_create :activate_user!
  after_create :approve_user!
  after_create :confirm_user!

  def self.find_by_username_email_or_phone(login)
    find_by_username(login) || find_by_email(login) || find_by_phone_number(login)
  end

  private

    def activate_user!
      self.active = true
    end

    def confirm_user!
      self.confirmed = true
    end

    def approve_user!
      self.approved = true
    end

    def ensure_email_or_phone
      if email.blank? && phone_number.blank?
        errors.add(:email, "must be present if phone number is empty.")
        errors.add(:phone_number, "must be present if email is empty.")
      end
    end
end
