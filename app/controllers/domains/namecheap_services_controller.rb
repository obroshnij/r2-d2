class Domains::NamecheapServicesController < ApplicationController
  respond_to :json

  def index
    @search = Domains::Compensation::NamecheapService.ransack params[:q]
    @services = @search.result(distinct: true).where(hidden: false).order(:name)

    if @services.find { |s| s.name =~ /coupon/ }
      @services = @services.sort_by { |s| s.name =~ /coupon code/ ? '!' : s.name }
    end
  end

end
