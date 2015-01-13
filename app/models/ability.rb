class Ability
  include CanCan::Ability

  def initialize(user)

  	user ||= User.new # guest user (not logged in)

    if user.role? :legal_and_abuse_manager
      can :read, Role
      can :manage, User
      can :manage, VipDomain
      can :manage, Spammer
      can :manage, :la_tool
    elsif user.role? :legal_and_abuse_c_s
      can :read, VipDomain
      can :read, Spammer
      can [:edit_password, :update_password], User
      can :manage, :la_tool
    else
      can [:edit_password, :update_password], User
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
