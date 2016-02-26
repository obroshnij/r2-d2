class WatchedDomainsController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    @search = WatchedDomain.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @domains = @search.result(distinct: true).order(:name).paginate(page: params[:page], per_page: @per_page)
  end
  
  def create
    @domain = WatchedDomain.new watched_domain_params
    if @domain.save
      flash[:notice] = "'#{@domain.name}' domain has been successfully saved"
    else
      flash[:alert] = "Failed to save '#{@domain.name}' domain: " + @domain.errors.full_messages.join('; ')
    end
    redirect_to action: :index
  end
  
  def destroy
    @domain = WatchedDomain.find params[:id]
    if @domain.destroy
      flash[:notice] = "'#{@domain.name}' domain has been successfully deleted"
    else
      flash[:alert] = "Failed to delete '#{@domain.name}' domain: " + @domain.errors.full_messages.join('; ')
    end
    redirect_to action: :index
  end
  
  private
  
  def watched_domain_params
    params.require(:watched_domain).permit(:name, :comment)
  end
  
end