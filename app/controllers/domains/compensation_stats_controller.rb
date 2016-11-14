class Domains::CompensationStatsController < ApplicationController
  respond_to :json

  def show
    authorize! :show, Domains::Compensation::Statistic
    @stats = Domains::Compensation::Statistic.new params[:date_range]
  end

end
