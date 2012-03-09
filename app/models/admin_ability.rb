# app/models/admin_ability.rb

# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    # We operate with two role levels:
    #  - User
    #  - Superuser

    # A user can manage users in their company
    can :read, Company

    # A superuser can to the following:
    if user.role?('superuser')
      can :manage, Company
      can :manage, User
    end
    
    can :manage, Company, :id => user.company_id
    
  end
end
