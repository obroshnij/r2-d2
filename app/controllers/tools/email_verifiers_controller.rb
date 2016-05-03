class Tools::EmailVerifiersController < ApplicationController
  respond_to :json
  
  def create
    @verifier = Tools::EmailVerifier.new params[:query]
    respond_with @verifier
  end
  
end