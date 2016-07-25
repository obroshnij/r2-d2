class Tools::InternalDomainsController < ApplicationController
  respond_to :json
  authorize_resource

  def index
    @search = Tools::InternalDomain.ransack params[:q]
    @internal_domains = @search.result(distinct: true).order(name: :asc).paginate(page: params[:page], per_page: params[:per_page])
  end

end
