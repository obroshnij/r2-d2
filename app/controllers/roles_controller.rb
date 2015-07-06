class RolesController < ApplicationController
  
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
    @roles = Role.accessible_by(current_ability) - [Role.find_by_name("Admin")]
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
  
  def update
    @role = Role.find params[:id]
    if @role.update_attributes role_params
      flash[:notice] = @role.name + " role has been successfully updated"
    else
      flash[:alert] = "Unable to update " + @role.name + " role: " + @role.errors.full_messages.join("; ")
    end
    redirect_to action: :edit
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
    params.require(:role).permit(:name, permissions_attributes: [:id, actions: [], subject_ids: []])
  end
  
end