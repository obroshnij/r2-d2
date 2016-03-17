class Tools::BulkWhoisLookup
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :id, :status, :whois_data, :domains_count, :failed_count, :successful_count, :created_at, :updated_at
  
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
  
  def self.by_user user, page = nil, per_page = nil
    jobs      = BackgroundJob.where(job_type: 'bulk_whois', user_id: user.id).order(created_at: :desc)
    paginated = jobs.paginate(page: page, per_page: per_page) if page && per_page
    lookups   = (paginated || jobs).map { |job| new(job) }
    
    lookups.define_singleton_method :total_entries, -> { jobs.count }
    lookups
  end
  
  def self.by_id id
    new BackgroundJob.find(id)
  end
  
  def initialize background_job = nil
    if background_job
      @id               = background_job.id
      @created_at       = background_job.created_at.strftime '%b/%d/%Y, %H:%M'
      @updated_at       = background_job.updated_at.strftime '%b/%d/%Y, %H:%M'
      @status           = background_job.status
      @whois_data       = background_job.data
      @domains_count    = @whois_data.count
      @failed_count     = @whois_data.select { |item| item['whois_record'].blank? }.count
      @successful_count = @whois_data.select { |item| item['whois_record'].present? }.count
    end
  end
  
  private
  
  def self.parse_domains query
    DomainName.parse_multiple(query).map &:name
  end
  
end