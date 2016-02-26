class Domains::WatchedDomainsController < ApplicationController
  respond_to :json
  authorize_resource
  
  def index
    @search = Domains::WatchedDomain.ransack params[:q]
    @watched_domains = @search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
  end
  
  def show
    @watched_domain = Domains::WatchedDomain.find params[:id]
  end
  
  def create
    @watched_domain = Domains::WatchedDomain.new watched_domain_params
    if @watched_domain.save
      render :show
    else
      respond_with @watched_domain
    end
  end
  
  def destroy
    domain = Domains::WatchedDomain.find params[:id]
    domain.destroy
    render json: {}
  end
  
  private
  
  def watched_domain_params
    params.require(:watched_domain).permit(:name, :comment)
  end
end