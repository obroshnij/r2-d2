class Ability
  
  include CanCan::Ability
  
  CLASSES = {
    ## Models
    user:                     %i( read update create delete ),
    role:                     %i( ), # actions are assigned in the before_save callback of the Permission model
                                     # depending on whether any roles are chosen
    abuse_report:             %i( read update create approve ),
    nc_user:                  %i( read create comment ),
    nc_service:               %i( read create comment ),
    :'legal/hosting_abuse' => %i( read create update ),
    rbl:                      %i( read create ),
    watched_domain:           %i( read create delete ),
    ## Controllers
    la_tool:                  %i( access ),
    manager_tool:             %i( access ),
    ## Custom actions
    maintenance_alert:        %i( create )
  }
  
  def initialize(user)
    
  	user ||= User.new # guest user (not logged in)
    
    can :manage, :all and return if user.admin?
    
    alias_action :destroy,                  to: :delete
    alias_action :manage,                   to: :access
    alias_action :update,                   to: :comment
    alias_action :update_abuse_report_form, to: :create
    
    user.permissions.each do |permission|
      
      if permission.actions.present?
        if permission.subject_ids.blank?
          can permission.actions.map(&:to_sym), permission.subject_class
        else
          can permission.actions.map(&:to_sym), permission.subject_class, id: permission.subject_ids
        end
      end
      
    end
    
    can [:edit_password, :update_password], User, id: user.id
  end
  
  def as_json
    @rules.map do |rule|
      { subjects: rule.subjects.map(&:to_s).map(&:classify), actions: rule.actions.map(&:to_s) }
    end
  end
  
end