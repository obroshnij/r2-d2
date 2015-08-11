class DdosInfo < ActiveRecord::Base
  # FreeDNS DDoS
  
  belongs_to :abuse_report
  
  # validates :amount_spent, :registered_domains, :client_ticket_id, presence: true
  # validates :amount_spent, numericality: true
  # validates :registered_domains, numericality: { only_integer: true }
  validates :last_signed_in_on_string, format: { with: /\d{1,2}\/\d{1,2}\/\d{4}/, message: "is not formatted properly" }, allow_blank: true
  validates :cfc_comment, presence: true, if: :cfc_status
  # validates :free_dns_domains, presence: true, if: :free_dns_ddos?
  # validates :free_dns_domains, numericality: { only_integer: true }, if: :free_dns_ddos?
  # validates :vendor_ticket_id, presence: true, if: :free_dns_ddos?
  
  after_create do
    username = self.abuse_report.report_assignments.direct.select { |a| a.reportable_type == 'NcUser' }.first.reportable.username
    self.abuse_report.report_assignments.direct.select { |a| a.reportable_type == 'NcService' }.each do |assignment|
      # TODO This overrides current domain owner if the domain has already been added
      assignment.reportable.assign_attributes nc_user_id: NcUser.find_by(username: username).id
      assignment.reportable.new_status = ServiceStatus.find_by_name('DDoS Related').id
      assignment.reportable.new_status = ServiceStatus.find_by_name('FreeDNS').id if self.target_service == 'FreeDNS'
      assignment.reportable.save
    end
  end
  
  def free_dns_ddos?
    self.target_service == 'FreeDNS'
  end
  
  # force client side validation
  def run_conditional(method_name_value_or_proc)
    (:cfc_status == method_name_value_or_proc) || (:free_dns_ddos? == method_name_value_or_proc) || super
  end
  
  def last_signed_in_on_string
    self.last_signed_in_on.try(:strftime, "%m/%d/%Y")
  end
  
  def last_signed_in_on_string=(date)
    self.last_signed_in_on = date.present? ? (Date.strptime(date.strip, "%m/%d/%Y") rescue nil) : nil
  end
  
end