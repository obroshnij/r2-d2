class AbuseReport < ActiveRecord::Base
  
  belongs_to :abuse_report_type
  has_many :report_assignments
  has_many :nc_users, through: :report_assignments, source: :reportable, source_type: "NcUser"
  has_many :nc_services, through: :report_assignments, source: :reportable, source_type: "NcService"
  
  has_one :spammer_info
  has_one :ddos_info
  has_one :private_email_info
  has_one :abuse_notes_info
  
  accepts_nested_attributes_for :spammer_info, :ddos_info, :private_email_info, :abuse_notes_info
  accepts_nested_attributes_for :report_assignments, reject_if: :all_blank, allow_destroy: true
  
  validates :reported_by, presence: true
  validates_associated :report_assignments, :spammer_info, :ddos_info, :private_email_info, :abuse_notes_info
  
  before_validation do
    if self.new_record?
      blank = self.report_assignments.select { |assignment| assignment.meta_data.present? }
      self.report_assignments -= blank
      blank.each { |assignment| self.report_assignments += assignment.split }
    end
  end
  
  scope :direct,   -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 1).uniq }
  scope :indirect, -> { joins(:report_assignments).where('report_assignments.report_assignment_type_id = ?', 2).uniq }
  
  def reportable_name
    case self.abuse_report_type_id
    when 1..2 # spammer, ddos
      self.report_assignments.direct.first.reportable.username
    when 3 # private email
      self.report_assignments.direct.first.reportable.name
    when 4 # abuse notes
      count = self.report_assignments.direct.count
      count.to_s + " domain".pluralize(count)
    end
  end
  
end