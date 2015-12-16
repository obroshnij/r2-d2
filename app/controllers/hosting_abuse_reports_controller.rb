class HostingAbuseReportsController < ApplicationController
  
  def new
    @form = HostingAbuseForm.new
  end
  
  def update_form
    @form = HostingAbuseForm.new nil, params[:hosting_abuse_form]
  end
  
end