# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    is_current_user?
  end

  def update? # edit? policy is same as this
    is_current_user?
  end

  private def is_current_user?
    record.id == user.id
  end
end
