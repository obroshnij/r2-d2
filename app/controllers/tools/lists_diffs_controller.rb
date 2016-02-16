class Tools::ListsDiffsController < ApplicationController
  respond_to :json
  
  def create
    @diff = Tools::ListsDiff.new params[:query_one], params[:query_two]
    respond_with @diff
  end
  
end