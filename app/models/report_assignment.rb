class ReportAssignment < ActiveRecord::Base
  
  belongs_to :reportable, polymorphic: true, dependent: :destroy
  belongs_to :abuse_report
  
  accepts_nested_attributes_for :reportable
  
  scope :direct,   -> { where(report_assignment_type_id: 1).uniq }
  scope :indirect, -> { where(report_assignment_type_id: 2).uniq }
  
  ## virtual attributes
  
  def usernames
    self.meta_data['usernames'] || []
  end
  
  def usernames=(usernames)
    self.meta_data['usernames'] = usernames.to_s.downcase.scan(/[a-z0-9]+/) if usernames.present?
  end
  
  def username
    self.meta_data['usernames'].try(:first)
  end
  
  def username=(username)
    self.meta_data['usernames'] = [username.strip.downcase] if username.present?
  end
  
  def relation_type_ids
    self.meta_data['relation_type_ids'] || []
  end
  
  def relation_type_ids=(ids)
    ids = ids.delete_if { |el| el.blank? }
    self.meta_data['relation_type_ids'] = ids if ids.present?
  end
  
  def registered_domains
    self.meta_data['registered_domains']
  end
  
  def registered_domains=(domains)
    self.meta_data['registered_domains'] = domains if domains.present?
  end
    
  def free_dns_domains
    self.meta_data['free_dns_domains']
  end
  
  def free_dns_domains=(domains)
    self.meta_data['free_dns_domains'] = domains if domains.present?
  end
    
  def comment
    self.meta_data['comment']
  end
  
  def comment=(comment)
    self.meta_data['comment'] = comment if comment.present?
  end

end