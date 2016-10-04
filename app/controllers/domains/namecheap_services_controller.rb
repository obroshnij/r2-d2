class Domains::NamecheapServicesController < ApplicationController
  respond_to :json

  def index
    @search = Domains::NamecheapService.ransack params[:q]
    @services = @search.result(distinct: true).order(:name)
  end

end
