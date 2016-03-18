class Tools::BulkWhoisLookup
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :id, :status, :whois_data, :domains, :failed, :successful, :created_at, :updated_at
  
  def self.enqueue query, keep_retrying, user
    domains = parse_domains query
    if domains.present?
      data    = domains.map { |name| { 'domain_name' => name } }
    
      job = BackgroundJob.create({
        job_type: 'bulk_whois',
        user_id:  user.id,
        status:   'Enqueued',
        data:     data,
        meta: {
          keep_retrying: (keep_retrying == 'true' || keep_retrying == true)
        }
      })
      
      BulkWhoisJob.perform_later job, 'In Progress'
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
      @job        = background_job
      @id         = @job.id
      @created_at = @job.created_at.strftime '%b/%d/%Y, %H:%M'
      @updated_at = @job.updated_at.strftime '%b/%d/%Y, %H:%M'
      @status     = @job.status
      @whois_data = format_whois_data @job.data
      @domains    = @whois_data.map    { |item| item['domain_name'] }
      @failed     = @whois_data.select { |item| item['whois_record'].blank? }.map   { |item| item['domain_name'] }
      @successful = @whois_data.select { |item| item['whois_record'].present? }.map { |item| item['domain_name'] }
    end
  end
  
  def retry
    @status = 'Enqueued'
    BulkWhoisJob.perform_later @job, 'Enqueued'
  end
  
  private
  
  def format_whois_data data
    data.each do |record|
      record['whois_attributes'].each do |key, val|
        record['whois_attributes'][key] = val.join("\n")                            if val.is_a?(Array)
        record['whois_attributes'][key] = DateTime.parse(val).strftime('%b %d, %Y') if key.to_s.include?('_date')
        record['whois_attributes'][key] = "Yes"                                     if val == true
        record['whois_attributes'][key] = "No"                                      if val == false
      end if record['whois_attributes'].present?
    end
    data
  end
  
  def self.parse_domains query
    DomainName.parse_multiple(query, remove_subdomains: true).map &:name
  end
  
end