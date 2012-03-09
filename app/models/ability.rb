# app/models/ability.rb

# All front end users are authorized using this class
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all
  end
end