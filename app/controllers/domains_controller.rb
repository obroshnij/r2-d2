class DomainsController < ApplicationController
  
  def index
    @search = NcService.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @domains = @search.result(distinct: true).where(nc_service_type_id: 1).paginate(page: params[:page], per_page: @per_page)
  end
  
  def create
    @domain = NcService.new domain_params
    if @domain.save
      flash[:notice] = "Domain name has been successfully saved"
    else
      flash[:alert] = "Failed to save domain name: " + @domain.errors.full_messages.join(", ")
    end
    redirect_to action: :index
  end
  
  private
  
  def domain_params
    params.require(:nc_service).permit(:nc_service_type_id, :username, :name, :new_status)
  end
  
end