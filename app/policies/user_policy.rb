# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    is_current_user?
  end

  def update?
    is_current_user?
  end

  private def is_current_user?
    record.id == user.id
  end
end
