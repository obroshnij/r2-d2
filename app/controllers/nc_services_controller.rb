class NcServicesController < ApplicationController
  
  before_action :authenticate_user!
  authorize_resource class: 'NcService'
  
  def index
    @search = NcService.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @services = @search.result(distinct: true).where(nc_service_type_id: service_type_id).paginate(page: params[:page], per_page: @per_page)
  end
  
  def create
    @service = NcService.new nc_service_params
    if @service.save
      flash[:notice] = "Domain name has been successfully saved"
    else
      flash[:alert] = "Failed to save domain name: " + @domain.errors.full_messages.join(", ")
    end
    redirect_to action: :index
  end
  
  private
  
  def nc_service_params
    params.require(:nc_service).permit(:nc_service_type_id, :username, :name, :new_status)
  end
  
end