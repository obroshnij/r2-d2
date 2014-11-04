class WhoisController < ApplicationController
  
  def new
  end

  def create
    begin
      @record = whois_lookup params[:name]
    rescue Exception => ex
      flash.now[:alert] = "Error: #{ex.message}"
    end
    render 'new'
  end

end
