# frozen_string_literal: true

class ApplicationPolicy
  REQUIRE_LOGIN_MSG = "Please log in before proceed."

  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, REQUIRE_LOGIN_MSG unless user
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private def does_user_own_record?
    record.user == user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, REQUIRE_LOGIN_MSG unless user
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
