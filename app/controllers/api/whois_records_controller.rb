class Api::WhoisRecordsController < ApplicationController
  
  respond_to :json
  
  def show
    res = { record: Whois.lookup(name) }
    respond_with res, status: 200
  rescue => exception
    res = { error: exception.message }
    respond_with res, status: 422
  end
  
  private
  
  def name
    params[:id].gsub('_', '.')
  end
  
end