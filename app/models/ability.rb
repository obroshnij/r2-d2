class Ability
  include CanCan::Ability

  def initialize(user)

  	user ||= User.new # guest user (not logged in)
    
    if user.role? :legal_and_abuse_manager
      can :read, Role, ["name LIKE ?", "%LegalAndAbuse%"] { |role| }
      can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%LegalAndAbuse%") do
        true
      end
      can :manage, :manager_tool
      can :manage, :la_tool
      can :manage, VipDomain
      can :manage, Spammer
      can :manage, InternalAccount
      
    elsif user.role? :legal_and_abuse_c_s
      can [:edit_password, :update_password], User
      can :manage, :la_tool
      can :read, VipDomain
      can :read, Spammer
      can :read, InternalAccount
      
    elsif user.role? :risk_management_manager
      can :read, Role, ["name LIKE ?", "%RiskManagement%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%RiskManagement%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :domains_manager
      can :read, Role, ["name LIKE ?", "%Domains%"] { |role| }
      can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%Domains%") do
        true
      end
      can :manage, :manager_tool
      can :read, :maintenance_alert
      
    elsif user.role? :domains_s_l
      can [:edit_password, :update_password], User
      can :read, :maintenance_alert
      
    elsif user.role? :hosting_manager
      can :read, Role, ["name LIKE ?", "%Hosting%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%Hosting%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :level2_manager
      can :read, Role, ["name LIKE ?", "%Level2%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%Level2%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :s_s_l_manager
      can :read, Role, ["name LIKE ?", "%SSL%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%SSL%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :transfer_concierge_manager
      can :read, Role, ["name LIKE ?", "%TransferConcierge%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%TransferConcierge%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :billing_manager
      can :read, Role, ["name LIKE ?", "%Billing%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%Billing%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :q_a_manager
      can :read, Role, ["name LIKE ?", "%QA%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%QA%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :training_manager
      can :read, Role, ["name LIKE ?", "%Training%"] { |role| }
      # can :manage, User, User.joins(:roles).where("roles.name LIKE ?", "%Training%") do
      #   true
      # end
      can [:edit_password, :update_password], User
      can :manage, :manager_tool
      
    elsif user.role? :admin
      can :manage, :all
            
    end
  end
end