class Domains::CompensationStatsController < ApplicationController
  respond_to :json

  def show
    @stats = Domains::Compensation::Stats.new params[:date_range]
  end

end
