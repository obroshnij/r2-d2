class LaToolsController < ApplicationController

  before_action :authenticate_user!
  authorize_resource class: false
  
  # Legal & Abuse > Spam
  def new
  end
  
  # Legal & Abuse > Spam, submit the form
  def parse
    @domains = DomainName.parse_multiple params[:text].downcase, remove_subdomains: true
    BackgroundJob.where(user_id: current_user.id, status: "Insufficient data").delete_all
    current_user.background_jobs.create status: "Insufficient data", info: "CSV file has not been uploaded", data: DomainName.multiple_to_hash(@domains)
    render action: :new
  end

  # Legal & Abuse > Spam, submit the form with CSV
  def append_csv
    job = BackgroundJob.find_by(user_id: current_user.id, status: "Insufficient data")
    data = SpamProcessor.parse_domains_info params[:domains_info].tempfile, job.data
    job.update_attributes data: data, status: "Pending", info: "Background job has been enqueued"
    SpamJob.perform_later(job)
    flash[:notice] = "Your request has been enqueued"
    redirect_to action: :spam_jobs
  end
  
  def spam_jobs
    @jobs = current_user.background_jobs.order(created_at: :desc)
  end
  
  def show_spam_job
    @job = BackgroundJob.find params[:id]
  end
  
  def delete_spam_job
    @job = BackgroundJob.find params[:id]
    if @job.delete
      flash[:noite] = "Spam report has been successfully deleted"
    else
      flash[:alert] = "Unable to delete spam report"
    end
    redirect_to action: :spam_jobs
  end
  
  # Legal & Abuse > DBL/SURBL Check
  def dbl_surbl
  end
  
  # Legal & Abuse > DBL/SURBL Check, submit the form
  def dbl_surbl_check
    @domains = DomainName.parse_multiple params[:query].downcase
    DNS::SpamBase.check_multiple @domains
    render action: :dbl_surbl
  end
  
  def bulk_curl
  end
  
  def perform_bulk_curl
    @result = CurlClient.process_multiple params[:urls].strip.split
    render action: :bulk_curl
  end
  
  def resource_abuse
  end

end