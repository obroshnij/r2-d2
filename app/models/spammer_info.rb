class SpammerInfo < ActiveRecord::Base
  # Internal Spammer Blacklist
  
  belongs_to :abuse_report
  
  def last_signed_in_on_string
    self.last_signed_in_on.try(:strftime, "%m/%d/%Y")
  end
  
  def last_signed_in_on_string=(date)
    self.last_signed_in_on = date.present? ? (Date.strptime(date.strip, "%m/%d/%Y") rescue nil) : nil
  end
  
  def attributes
    super.merge("last_signed_in_on_string" => self.last_signed_in_on_string)
  end
  
end