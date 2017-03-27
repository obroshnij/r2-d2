class Tools::EmailMaskersController < ApplicationController
  respond_to :json

  def create
    @masker = Tools::EmailMasker.new params[:query]
    respond_with @masker
  end

end
