class Domains::Compensation::LogSerializer < ApplicationSerializer
  attributes :user, :action, :payload, :created_at

  def user
    object.user.name
  end

  def created_at
    object.created_at.strftime '%b/%d/%Y, %H:%M'
  end
end
