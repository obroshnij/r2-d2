class Tools::BulkDigsController < ApplicationController
  respond_to :json
  
  def create
    @bulk_dig = Tools::BulkDig.new params[:query], params[:record_types], params[:nameservers]
    respond_with @bulk_dig
  end
  
end