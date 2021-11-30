class LobbyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    return true
  end

  def update?
    record.owner == user
  end

  def start_game?
    record.owner == user
  end
end
