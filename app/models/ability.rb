class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    user.role.permissions.each { |p| can p.actions, p.subject_classes, eval(p.conditions) } if user && user.role
  end
  
  def as_json
    (@rules || []).map do |rule|
      {
        subjects:   rule.subjects.map(&:to_s).map(&:classify),
        actions:    rule.actions.map(&:to_s),
        conditions: rule.conditions
      }
    end
  end
  
end