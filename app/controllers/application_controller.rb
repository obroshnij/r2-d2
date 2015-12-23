class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    
  include MaintenanceAlertsHelper
  include DomainBoxHelper
  include LaToolsHelper
  include ManagerToolsHelper
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
  
  def index
    gon.hosting_abuse_services                     = HostingAbuseInfo::HostingService.all
    gon.hosting_abuse_types                        = HostingAbuseInfo::AbuseType.all
    gon.hosting_abuse_shared_packages              = HostingAbuseInfo::SharedPackage.all
    gon.hosting_abuse_reseller_packages            = HostingAbuseInfo::ResellerPackage.all
    gon.hosting_abuse_management_types             = HostingAbuseInfo::ManagementType.all
    gon.hosting_abuse_suggestions                  = HostingAbuseInfo::Suggestion.all
    gon.hosting_abuse_spam_detection_methods       = HostingAbuseSpam::DetectionMethod.all
    gon.hosting_abuse_spam_reporting_parties       = HostingAbuseSpam::ReportingParty.all
    gon.hosting_abuse_resource_abuse_types         = HostingAbuseResource::ResourceAbuseType.all
    gon.hosting_abuse_resource_activity_types      = HostingAbuseResource::ActivityType.all
    gon.hosting_abuse_resource_measures            = HostingAbuseResource::Measure.all
    gon.hosting_abuse_resource_types               = HostingAbuseResource::ResourceType.all
    gon.hosting_abuse_resource_upgrade_suggestions = HostingAbuseResource::UpgradeSuggestion.all
    gon.hosting_abuse_resource_impacts             = HostingAbuseResource::Impact.all
    
    gon.current_user = current_user
    render layout: 'application_new'
  end
  
end