class Legal::HostingAbuseController < ApplicationController
  respond_to :json
  
  def create
    @form = Legal::HostingAbuse::Form.new
    if @form.submit params
    else
      respond_with @form
    end
  end
  
end