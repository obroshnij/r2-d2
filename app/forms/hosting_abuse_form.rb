class HostingAbuseForm
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :hosting_service,    String
  attribute :hosting_abuse_type, String
  attribute :server_name,        String
  attribute :username,           String
  attribute :owner,              String
  attribute :management_type,    String
  attribute :server_rack_label,  String
  attribute :package,            String
  
  attribute :suggestion,         String
  attribute :scan_report_path,   String
  attribute :comments,           String
  
  HOSTING_SERVICES = {
    shared:    'Shared Package',
    reseller:  'Reseller Package',
    vps:       'VPS Hosting',
    dedicated: 'Dedicated Server',
    pe:        'Private Email'
  }
  
  HOSTING_ABUSE_TYPES = {
    spam:        'Email Abuse / Spam',
    ip_feedback: 'IP Feedback',
    lve_mysql:   'Resource Abuse (LVE/MySQL)',
    disc_space:  'Resource Abuse (Disc Space)',
    cron_job:    'Resource Abuse (Cron Jobs)',
    ddos:        'DDoS'
  }
  
  MANAGEMENT_TYPES = {
    not_managed:       'None',
    partially_managed: 'Partially Managed',
    fully_managed:     'Fully Managed'
  }
  
  SUGGESTIONS = {
    six:         "6 Hours",
    twelve:      "12 Hours",
    twenty_four: "24 Hours",
    to_suspend:  "To Suspend",
    suspended:   "Already Suspended"
  }
  
  def initialize report_id = nil, params = nil
    self.attributes = params if params.present?
  end
  
  def abuse_part
    @abuse_part ||= get_abuse_part
  end
  
  def get_abuse_part
    sub_form = ('HostingAbuseForm::' + self.hosting_abuse_type.classify).constantize.new rescue nil
    sub_form.service = self.hosting_service if sub_form
    sub_form
  end
    
  def hosting_services
    HostingAbuseInfo.hosting_services.map { |s| [HOSTING_SERVICES[s.first.to_sym], s.first] }
  end
  
  def hosting_abuse_types
    HostingAbuseInfo.hosting_abuse_types.map { |t| [HOSTING_ABUSE_TYPES[t.first.to_sym], t.first] }
  end
  
  def management_types
    HostingAbuseInfo.management_types.map { |t| [MANAGEMENT_TYPES[t.first.to_sym], t.first] }
  end
  
  def packages
    HostingAbuseInfo.packages.map { |p| [p.first.humanize, p.first] }
  end
  
  def suggestions
    HostingAbuseInfo.suggestions.map { |s| [SUGGESTIONS[s.first.to_sym], s.first] }
  end
  
end