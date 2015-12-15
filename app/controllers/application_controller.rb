class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    
  include MaintenanceAlertsHelper
  include DomainBoxHelper
  include LaToolsHelper
  include ManagerToolsHelper
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
  
  def index
    gon.current_user = current_user
    render layout: 'application_new'
  end
  
end