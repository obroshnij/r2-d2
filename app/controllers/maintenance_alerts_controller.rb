class MaintenanceAlertsController < ApplicationController

  def index
  	begin
      @alerts = parse_alerts
    # rescue Exception => ex
    #   flash.now[:alert] = "Error: #{ex.message}"
    end
  end

end
