class Tools::BulkWhoisLookup
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :id, :status, :whois_data
  
  def self.enqueue query, user
    domains = parse_domains query
    if domains.present?
      data    = domains.map { |name| { 'domain_name' => name } }
    
      job = BackgroundJob.create(job_type: 'bulk_whois', user_id: user.id, status: 'Enqueued', data: data)
      BulkWhoisJob.perform_later job
      new job
    else
      lookup = new
      lookup.errors.add :query, 'no domains found'
      lookup
    end
  end
  
  def self.by_user user
    BackgroundJob.where(job_type: 'bulk_whois', user_id: user.id).map { |job| new(job) }
  end
  
  def self.by_id id
    new BackgroundJob.find(id)
  end
  
  def initialize background_job = nil
    if background_job
      @id               = background_job.id
      @status           = background_job.status
      @whois_data       = background_job.data
      @total_count      = @whois_data.count
      @failed_count     = @whois_data.select { |item| item['whois_record'].blank? }.count
      @successful_count = @whois_data.select { |item| item['whois_record'].present? }.count
    end
  end
  
  private
  
  def self.parse_domains query
    DomainName.parse_multiple(query).map &:name
  end
  
end