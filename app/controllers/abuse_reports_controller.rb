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
    @abuse_report.bulk_relations.build
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
      flash[:notice] = "Abuse report has been successfully updates"
    else
      flash[:alert] = "Failed to update abuse report: " + @abuse_report.errors.full_messages.join("; ")
    end
    redirect_to action: :index
  end
  
  private
  
  def abuse_report_params
    params.require(:abuse_report).permit(:abuse_report_type_id, :reported_by, :processed_by, :processed, :comment,
                   nc_user_attributes: [:id, :username, :signed_up_on_string, :new_status],
                   spammer_info_attributes: spammer_info_params,
                   bulk_relations_attributes: [:id, :usernames, relation_type_ids: []])
  end
  
  def spammer_info_params
    [:id, :amount_spent, :last_signed_in_on_string, :registered_domains, :abused_domains, :locked_domains, :abused_locked_domains,
     :responded_previously, :reference_ticket_id, :comment, :cfc_status, :cfc_comment]
  end
  
end