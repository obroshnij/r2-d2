class Legal::Rbl::CheckersController < ApplicationController
  respond_to :json
  
  def create
    @checker = Legal::Rbl::Checker.new params[:query]
    respond_with @checker
  end
  
end