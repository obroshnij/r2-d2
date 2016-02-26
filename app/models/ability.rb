class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    user.role.permissions.each do |p|
      can p.action.to_sym, p.resource.constantize, eval(p.conditions)
    end
    
    can :manage, :all
    
  end
  
  def as_json
    @rules.map do |rule|
      { subjects: rule.subjects.map(&:to_s).map(&:classify), actions: rule.actions.map(&:to_s) }
    end
  end
  
end