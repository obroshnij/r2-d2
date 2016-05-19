class Domains::WatchedDomain < ActiveRecord::Base
  self.table_name = 'watched_domains'
  
  validates :name,  presence: true, host_name: true
  validates :name,  uniqueness: { case_sensitive: false, message: 'has already been added' }
  validates :email, presence: true
  
  before_validation do
    self.name = self.name.strip.downcase
  end
  
  before_save do
    self.status = self.new_status
  end
  
  def new_status
    if self.valid?
      return whois[:status] if whois[:status].present?
      return ['unknown']    if whois[:available] == 'unknown'
      whois[:available] ? ['available'] : ['registered']
    end
  end
  
  private
  
  def whois
    @whois ||= get_whois
  end
  
  def get_whois
    Timeout::timeout(25) do
      whois_prop = nil
      whois_prop = DomainName.new(self.name).whois!.properties while whois_prop.nil?
      whois_prop
    end
  end
end