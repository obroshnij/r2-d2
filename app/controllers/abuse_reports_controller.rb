class AbuseReportsController < ApplicationController
  
  def index
    @search = AbuseReport.ransack params[:q]
    @per_page = params[:per_page].blank? ? 25 : params[:per_page]
    @abuse_reports = @search.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end
  
  def new
  end
  
  def update_abuse_report_form
    @abuse_report = AbuseReport.new abuse_report_type: AbuseReportType.find(params[:abuse_report_type_id])
  end
  
  def create
    @abuse_report = AbuseReport.new abuse_report_params
    if @abuse_report.save
      flash[:notice] = "Abuse report has been successfully submitted"
      redirect_to action: :index
    else
      flash.now[:alert] = "Unable to submit abuse report: " + @abuse_report.errors.full_messages.join("; ")
      render action: :new
    end
  end
  
  def update
    @abuse_report = AbuseReport.find params[:id]
    if @abuse_report.update_attributes abuse_report_params
      flash[:notice] = "Abuse report has been successfully updated"
    else
      flash[:alert] = "Failed to update abuse report: " + @abuse_report.errors.full_messages.join("; ")
    end
    redirect_to action: :index
  end
  
  private
  
  def abuse_report_params
    params.require(:abuse_report).permit(:abuse_report_type_id, :reported_by, :processed_by, :processed, :comment,
                   spammer_info_attributes: spammer_info_params, ddos_info_attributes: ddos_info_params,
                   private_email_info_attributes: private_email_info_params, abuse_notes_info_attributes: abuse_notes_info_params,
                   report_assignments_attributes: report_assignments_params)
  end
  
  def report_assignments_params
    [:id, :reportable_type, :report_assignment_type_id, :username, :usernames, :registered_domains, :free_dns_domains, :domains, :comment,
     relation_type_ids: [], reportable_attributes: reportable_params]
  end
  
  def reportable_params
    [:id, :username, :name, :signed_up_on_string, :nc_service_type_id, :new_status]
  end
  
  def spammer_info_params
    [:id, :amount_spent, :last_signed_in_on_string, :registered_domains, :abused_domains, :locked_domains, :abused_locked_domains,
     :responded_previously, :reference_ticket_id, :cfc_status, :cfc_comment]
  end
  
  def ddos_info_params
    [:id, :amount_spent, :last_signed_in_on_string, :registered_domains, :free_dns_domains, :cfc_status, :cfc_comment, :vendor_ticket_id, :client_ticket_id]
  end
  
  def private_email_info_params
    [:id, :suspended, :reported_by, :warning_ticket_id]
  end
  
  def abuse_notes_info_params
    [:id, :reported_by]
  end
  
end