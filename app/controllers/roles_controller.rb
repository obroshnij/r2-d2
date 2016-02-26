class RolesController < ApplicationController
  respond_to :json
  authorize_resource
  
  def index
    @search = Role.ransack params[:q]
    @roles = @search.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
  end
  
  def show
    @role = Role.find params[:id]
  end
  
end