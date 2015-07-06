class UsersController < ApplicationController
  
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @search = User.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @users = @search.result(distinct: true).accessible_by(current_ability).paginate(page: params[:page], per_page: @per_page)
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    if @user.destroy
      flash[:notice] = "User account has been successfully deleted"
    else
      flash[:alert] = "Unable to delete user account: #{@user.errors.full_messages.join("; ")}"
    end
    redirect_to action: :index
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:notice] = "User account has been successfully created"
      redirect_to action: :index
    else
      flash[:alert] = "Unable to create user account: #{@user.errors.full_messages.join("; ")}"
      redirect_to action: :index
    end
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      flash[:notice] = "User account has been successfully updated"
      redirect_to action: :index
    else
      flash.now[:alert] = "Unable to update user account: #{@user.errors.full_messages.join("; ")}"
      render action: :edit
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_with_password user_params
      # Sign in the user by passing validation in case their password changed
      sign_in @user, bypass: true
      flash[:notice] = "Password has been successfully updated"
      redirect_to action: :edit_password
    else
      flash.now[:alert] = "Unable to update password: #{@user.errors.full_messages.join("; ")}"
      render action: :edit_password
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, role_ids: [])
  end

end