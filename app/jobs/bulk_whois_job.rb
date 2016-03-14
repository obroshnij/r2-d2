class BulkWhoisJob < ActiveJob::Base
  queue_as :default
  
  def perform job
    job.update_attributes status: 'In Progress'
    
    job.data.each do |hash|
      name = DomainName.new hash['domain_name']
      name.whois!
      
      hash['whois_record']     = name.whois.record
      hash['whois_attributes'] = name.whois.properties
    end
    
    job.status = 'Complete'
    job.save
  end
  
end