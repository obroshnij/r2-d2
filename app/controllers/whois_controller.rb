class WhoisController < ApplicationController
  
  def new
  end

  def create
    begin
      @record = lookup params[:name].strip
    rescue Exception => ex
      flash.now[:alert] = "Error: #{ex.message}"
    end
    render 'new'
  end

end
