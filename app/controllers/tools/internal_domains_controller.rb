class Tools::InternalDomainsController < ApplicationController
  respond_to :json
  authorize_resource

  def index
    @search = Tools::InternalDomain.ransack params[:q]
    @internal_domains = @search.result(distinct: true).order(name: :asc).paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @internal_domain = Tools::InternalDomain.find params[:id]
  end

  def create
    @internal_domain = Tools::InternalDomain.new internal_domain_params
    if @internal_domain.save
      render :show
    else
      respond_with @internal_domain
    end
  end

  def update
    @internal_domain = Tools::InternalDomain.find params[:id]
    if @internal_domain.update_attributes(internal_domain_params)
      render :show
    else
      respond_with @internal_domain
    end
  end

  def destroy
    domain = Tools::InternalDomain.find params[:id]
    domain.destroy
    render json: {}
  end

  private

  def internal_domain_params
    params.require(:internal_domain).permit(:name, :comment)
  end

end
