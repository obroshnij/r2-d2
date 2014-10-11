class WhoisController < ApplicationController
  def new
  end

  def create
  	@domain = Domain.new(params[:name])
  	render 'new'
  end
end
