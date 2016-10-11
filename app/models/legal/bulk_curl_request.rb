class Legal::BulkCurlRequest
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :id, :status, :urls, :created_at, :updated_at, :results
  
  def self.enqueue urls, user
    urls = split_urls urls
    if urls.any?
    
      job = BackgroundJob.create({
        job_type: 'bulk_curl',
        user_id:  user.id,
        status:   'Enqueued',
        meta:     urls
      })

      BulkCurlJob.perform_later job, 'In Progress'
      new job
    else
      lookup = new
      lookup.errors.add :urls, 'no urls specified'
      lookup
    end
  end
  
  def self.by_user user, page = nil, per_page = nil
    jobs      = BackgroundJob.where(job_type: 'bulk_curl', user_id: user.id).order(created_at: :desc)
    paginated = jobs.paginate(page: page, per_page: per_page) if page && per_page
    requests = (paginated || jobs).map { |job| new(job) }
    
    requests.define_singleton_method :total_entries, -> { jobs.count }
    requests
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
      @urls       = @job.meta
      @results    = @job.data
    end
  end

  private

  def self.split_urls(urls)
    urls.length > 0 ? urls.strip.split : []
  end
  
end