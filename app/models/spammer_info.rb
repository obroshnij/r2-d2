class SpammerInfo < ActiveRecord::Base
  # Internal Spammer Blacklist
  
  belongs_to :abuse_report
  
  # validates :amount_spent, :registered_domains, :abused_domains, :locked_domains, :abused_locked_domains, presence: true
  # validates :amount_spent, numericality: true
  # validates :registered_domains, :abused_domains, :locked_domains, :abused_locked_domains, numericality: { only_integer: true }
  validates :last_signed_in_on_string, format: { with: /\d{1,2}\/\d{1,2}\/\d{4}/, message: "is not formatted properly" }, allow_blank: true
  validates :reference_ticket_id, presence: true, if: :responded_previously
  validates :cfc_comment, presence: true, if: :cfc_status
  
  # force client side validation
  def run_conditional(method_name_value_or_proc)
    (:responded_previously == method_name_value_or_proc) || (:cfc_status == method_name_value_or_proc) || super
  end
  
  def last_signed_in_on_string
    self.last_signed_in_on.try(:strftime, "%m/%d/%Y")
  end
  
  def last_signed_in_on_string=(date)
    self.last_signed_in_on = date.present? ? (Date.strptime(date.strip, "%m/%d/%Y") rescue nil) : nil
  end
  
end