class Legal::HostingAbuseController < ApplicationController
  respond_to :json
  
  def show
    @hosting_abuse = Legal::HostingAbuse.find params[:id]
  end
  
  def create
    @form = Legal::HostingAbuse::Form.new
    if @form.submit params
      @hosting_abuse = @form.model
      render :show
    else
      respond_with @form
    end
  end
  
end