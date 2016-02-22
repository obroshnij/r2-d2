class RolesController < ApplicationController
  
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
    respond_to do |format|
      format.html do
        @roles = Role.accessible_by(current_ability) - [Role.find_by_name("Admin")]
      end
      
      format.json do
        @search = Role.ransack params[:q]
        @roles = @search.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
      end
    end
  end
  
  def create
    @role = Role.new role_params
    if @role.save
      flash[:notie] = @role.name + " role has been successfully saved"
    else
      flash[:alert] = "Unable to save " + @role.name + " role: " + @role.errors.full_messages.join("; ")
    end
    redirect_to action: :index
  end
  
  def edit
    @role = Role.find params[:id]
    @permissions = Ability::CLASSES.keys.map do |class_name|
      Permission.find_or_create_by role_id: params[:id], subject_class: class_name
    end
  end
  
  def show
    @role = Role.find params[:id]
  end
  
  def update
    @role = Role.find params[:id]
    respond_to do |format|
      if @role.update_attributes role_params
        format.html do
          flash[:notice] = @role.name + " role has been successfully updated"
          redirect_to action: :edit
        end
        
        format.json do
          render action: :show
        end
      else
        format.html do
          flash[:alert] = "Unable to update " + @role.name + " role: " + @role.errors.full_messages.join("; ")
          redirect_to action: :edit
        end
      end
    end
  end
  
  def destroy
    @role = Role.find params[:id]
    if @role.destroy
      flash[:notice] = @role.name + " role has been successfully deleted"
    else
      flash[:alert] = "Unable to delete " + @role.name + " role: " + @role.errors.full_messages.join("; ")
    end
    redirect_to action: :index
  end
  
  private
  
  def role_params
    params.require(:role).permit(:name, group_ids: [], permissions_attributes: [:id, actions: [], subject_ids: []])
  end
  
end