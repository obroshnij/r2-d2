class UsersController < ApplicationController
  
  before_action :authenticate_user!
  before_filter :get_user, only: [:index, :new, :edit]
  before_filter :accessible_roles, only: [:new, :edit, :show, :update, :create]
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability, :index)
  end

  def new
  end

  def show
  end

  def edit
  end

  def destroy
    flash[:notice] = "The user has been deleted" if @user.destroy
    redirect_to action: :index
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "The account has been created"
      redirect_to action: :index
    else
      flash.now[:alert] = @user.errors.full_messages.join("; ")
      render action: :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "The account has been updated"
      redirect_to action: :index
    else
      flash.now[:alert] = @user.errors.full_messages.join("; ")
      render action: :edit
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, bypass: true
      flash[:notice] = "Password has been updated"
      redirect_to action: :edit_password
    else
      flash.now[:alert] = @user.errors.full_messages.join("; ")
      render "edit_password"
    end
  end

  private

  def accessible_roles
    @accessible_roles = Role.accessible_by(current_ability, :read)
  end
 
  def get_user
    @current_user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, role_ids: [])
  end

end