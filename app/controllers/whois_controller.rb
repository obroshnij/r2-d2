class WhoisController < ApplicationController
  def new
  end

  def create
  	@record = Whois.whois(params[:name])
  	render 'new'
  rescue Exception => ex
  	flash.now[:alert] = "#{ex.class}: #{ex.message}"
    render 'new'
  end
end
