class WhoisLookupsController < ApplicationController
  
  respond_to :json
  
  def show
    res = params[:domain]
    render json: res
  end
  
end