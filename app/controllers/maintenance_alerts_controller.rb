class MaintenanceAlertsController < ApplicationController
  
  def index
    authorize! :index, :maintenance_alert
    @alerts = parse_alerts
  end

end