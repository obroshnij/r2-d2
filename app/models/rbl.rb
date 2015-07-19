class Rbl < ActiveRecord::Base
  
  belongs_to :rbl_status
  
  validates :name, :rbl_status_id, presence: true
  
  before_save do
    self.url = self.url.strip.downcase if self.url.present?
    self.name.strip!
  end
  
  def row_class
    return "red"    if self.rbl_status.name == "Urgent"
    return "yellow" if self.rbl_status.name == "Important"
    return "blue"   if self.rbl_status.name == "Unimportant"
  end
  
end