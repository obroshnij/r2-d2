class Legal::DblSurblChecksController < ApplicationController
  respond_to :json

  def create
    @check = Legal::DblSurblCheck.new params[:query]
    respond_with @check
  end
end
