class RblsController < ApplicationController
  
  before_action :authenticate_user!
  authorize_resource
  
  def index
    @search = Rbl.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @rbls = @search.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
  
  def create
    @rbl = Rbl.new rbl_params
    if @rbl.save
      flash[:notice] = "RBL has been successfully saved"
    else
      flash[:alert] = "Unable to save RBL: " + @rbl.errors.full_messages.join('; ')
    end
    redirect_to action: :index
  end
  
  private
  
  def rbl_params
    params.require(:rbl).permit(:name, :url, :rbl_status_id)
  end
  
end