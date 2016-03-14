class Tools::BulkWhoisLookupsController < ApplicationController
  respond_to :json
  
  def create
    @lookup = Tools::BulkWhoisLookup.enqueue params[:query], current_user
    respond_with @lookup
  end
  
end