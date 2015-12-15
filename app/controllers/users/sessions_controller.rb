class Users::SessionsController < Devise::SessionsController
  
  def new
    super
    session[:user_return_to] = "/r2/#{params[:frag]}" if params[:frag]
  end
  
end
