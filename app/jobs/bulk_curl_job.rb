class BulkCurlJob < ActiveJob::Base
  queue_as :bulk_curl

  def perform job, status
    job.update_attribute :status, status
    job.data = process_urls_for(job)
    job.status = 'Processed'
    job.save
  end

  private

  def process_urls_for job
    urls = job.meta
    urls.length > 0 ? CurlClient.process_multiple(urls) : []
  end

end
