class BulkWhoisJob < ActiveJob::Base
  queue_as :default
  
  def perform job, status
    job.update_attributes status: status
    perform_lookup job
    job.status = get_status job
    job.save
    BulkWhoisJob.set(wait: 5.minutes).perform_later(job) if job.status == 'Will Retry'
  end
  
  private
  
  def perform_lookup job
    job.data.each do |hash|
      if hash['whois_record'].blank?
        name = DomainName.new hash['domain_name']
        name.whois!
      
        hash['whois_record']     = name.whois.record
        hash['whois_attributes'] = name.whois.properties
      end
    end
  end
  
  def failed? job
    job.data.find { |hash| hash['whois_record'].blank? }.present?
  end
  
  def get_status job
    return 'Will Retry' if failed?(job) && job.meta['keep_retrying']
    return 'Faild'      if failed?(job)
    'Completed'
  end
  
end