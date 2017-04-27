class Api::V1::BaseController < ActionController::Base
  respond_to :json
  before_action :authenticate_user!

  rescue_from Api::Unauthorized do |exception|
    render json: { error: exception.message }, status: 401
  end

  private

  attr_reader :current_user

  def authenticate_user!
    raise Api::Unauthorized, 'uid is missing'     unless params[:uid]
    raise Api::Unauthorized, 'api key is missing' unless params[:api_key]

    @current_user = User.find_by uid: params[:uid], api_key: params[:api_key]

    raise Api::Unauthorized, 'invalid credentials' unless @current_user
  end

end
