class Tools::WhoisLookupsController < ApplicationController
  respond_to :json
  
  def create
    @whois_lookup = Tools::WhoisLookup.new params[:query]
    respond_with @whois_lookup
  end
  
end