class RolesController < ApplicationController
  respond_to :json
  authorize_resource
  
  def index
    @search = Role.ransack params[:q]
    @roles = @search.result(distinct: true).order(:name).paginate(page: params[:page], per_page: params[:per_page])
  end
  
  def create
    @role = Role.new role_params
    if @role.save
      render :show
    else
      respond_with @role
    end
  end
  
  def show
    @role = Role.find params[:id]
  end
  
  def update
    @role = Role.find params[:id]
    if @role.update_attributes role_params
      render :show
    else
      respond_with @role
    end
  end
  
  def destroy
    @role = Role.find params[:id]
    if @role.destroy
      render json: {}
    else
      respond_with @role
    end
  end
  
  private
  
  def role_params
    params.require(:role).permit(:id, :name, permission_ids: [], group_ids: [])
  end
  
end