class AbuseReportsController < ApplicationController
  
  def new
  end
  
  def update_abuse_report_form
    @abuse_report = AbuseReport.new abuse_report_type: AbuseReportType.find(params[:abuse_report_type_id])
    @abuse_report.bulk_relations.build
  end
  
  def create
  end
  
end