class Legal::NcUsersController < ApplicationController

  wrap_parameters :nc_user, include: Legal::NcUser.attribute_names + %w{ new_status signed_up_on_string }

  respond_to :json

  authorize_resource
  
  def index
    @search = Legal::NcUser.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @nc_users = @search.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
  
  def create
    @nc_user = Legal::NcUser.new nc_user_params

    if @nc_user.save
      flash[:notice] = "Namecheap user has been successfully saved"
    else
      flash[:alert] = "Failed to save namecheap user: " + @nc_user.errors.full_messages.join("; ")
    end

    redirect_to action: :index
  end
  
  def show
    @nc_user = Legal::NcUser.find params[:id]
  end
  
  def update
    @nc_user = Legal::NcUser.find params[:id]
    if @nc_user.update_attributes nc_user_params
      flash[:notice] = "User details have been successsfully updated"
    else
      flash[:alert] = "Failed to save updates: " + @nc_user.errors.full_messages.join("; ")
    end
    redirect_to action: :show
  end
  
  private
  
  def nc_user_params
    params.require(:nc_user).permit(:username, :signed_up_on_string, :new_status, comments_attributes: [:id, :user_id, :content])
  end
  
end