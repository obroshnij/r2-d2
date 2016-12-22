class SpamJob < ActiveJob::Base
  queue_as :whois

  def perform(job)
    job.update_attributes status: "Pending", info: "Background job is being processed"
    SpamProcessor.process(job)
    if job.status == "Failed"
      SpamJob.set(wait: 5.minutes).perform_later(job)
      job.update_attributes status: "Failed, will retry on #{(DateTime.now + 5.minutes).strftime('%d %b %Y at %H:%M')}"
    end
  end

end
