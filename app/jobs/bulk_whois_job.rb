class BulkWhoisJob < ActiveJob::Base
  queue_as :whois

  def perform job, status
    job.update_attributes status: status
    perform_lookup job
    job.meta['tries_count'] = get_tries_count job
    job.status = get_status job
    job.save
    BulkWhoisJob.set(wait: 5.minutes).perform_later(job, 'In Progress') if job.status == 'Pending Retrial'
  end

  private

  def perform_lookup job
    domains = get_domains_with_blank_whois job
    Whois.lookup_multiple domains

    domains.each do |domain|
      item = job.data.find { |item| item['domain_name'] == domain.name }
      item['whois_record']     = domain.whois.record
      item['whois_attributes'] = domain.whois.properties
    end
  end

  def get_domains_with_blank_whois job
    job.data.select { |item| item['whois_record'].blank? }.map! { |item| DomainName.new item['domain_name'] }
  end

  def failed? job
    job.data.find { |hash| hash['whois_record'].blank? }.present?
  end

  def get_status job
    return 'Pending Retrial'  if failed?(job) && job.meta['keep_retrying'] && job.meta['tries_count'] < 5
    return 'Partially Failed' if failed?(job)
    'Completed'
  end

  def get_tries_count job
    (job.meta['tries_count'] || 0) + 1
  end

end
