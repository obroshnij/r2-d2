class UsersController < ApplicationController
  respond_to :json
  authorize_resource

  def index
    @search = User.ransack params[:q]
    @users = @search.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
  end
  
  def show
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      render :show
    else
      respond_with @user
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:id, :auto_role, :role_id)
  end
  
end