class Legal::Rbl < ActiveRecord::Base
  self.table_name = 'rbls'
  
  belongs_to :status, class_name: 'Legal::RblStatus', foreign_key: 'rbl_status_id'
  
  validates :name, :rbl_status_id, presence: true
  
  store_accessor :data, :comment
  
  def self.attribute_names
    super + ['comment']
  end
  
  before_save do
    self.url = url.strip.downcase if url.present?
    self.name.strip!
  end
  
  LIST_TYPES = {
    'w' => 'whitelist',
    'b' => 'blacklist',
    'i' => 'informationallist',
    'c' => 'combinedlist'
  }
  
  def pull_data_from_valli_org
    return if data['multirbl_id'].blank?
    
    html = Nokogiri::HTML(open("http://multirbl.valli.org/detail/#{data['multirbl_id']}.html"))
    tr   = html.css('table')[0].css('tr')
    
    self.data['rip']          = tr[1].css('td')[1].text == '1'
    self.data['private']      = tr[2].css('td')[1].text == '1'
    self.data['name']         = tr[3].css('td')[1].text
    self.data['dns_zone']     = tr[4].css('td')[1].text
    self.data['ipv4']         = tr[5].css('td')[1].text == '1'
    self.data['ipv6']         = tr[6].css('td')[1].text == '1'
    self.data['domain_uri']   = tr[7].css('td')[1].text == '1'
    self.data['type']         = LIST_TYPES[tr[8].css('td')[1].text]
    self.data['url']          = tr[9].css('td')[1].text
    self.data['has_only_txt'] = tr[10].css('td')[1].text == '1'
    
    self.save
  end
  
end