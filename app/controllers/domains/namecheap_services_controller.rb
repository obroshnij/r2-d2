class Domains::NamecheapServicesController < ApplicationController
  respond_to :json

  def index
    @search = Domains::Compensation::NamecheapService.ransack params[:q]
    @services = @search.result(distinct: true).where(hidden: false).order(:name)
  end

end
