class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  include MaintenanceAlertsHelper
  include LaToolsHelper
  include DomainBoxHelper

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|

      format.html do
        flash[:alert] = exception.message
        redirect_to root_url
      end

      format.json do
        render json: { error: "You don't have enough permissions to perform this action" }, status: 403
      end

    end
  end

  def index
    gon.rabl
    render layout: 'application_new'
  end

end
