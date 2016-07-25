class Tools::DataSearchesController < ApplicationController
  respond_to :json

  def create
    @data_search = Tools::DataSearch.new params[:query], params[:object_type], params[:internal]
    respond_with @data_search
  end

end
