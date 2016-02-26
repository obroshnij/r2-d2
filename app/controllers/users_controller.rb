class UsersController < ApplicationController
  respond_to :json
  authorize_resource

  def index
    @search = User.ransack params[:q]
    @users = @search.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
  end
  
end