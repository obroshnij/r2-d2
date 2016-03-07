class WatchDomainsJob < ActiveJob::Base
  queue_as :default

  def perform
    names = Domains::WatchedDomain.all
    diff = {}
    if names.present?
      names.each do |name|
        begin
          unless name.status.sort == name.new_status.sort
            diff[name.name] = { status: [name.status.join(', '), name.new_status.join(', ')], comment: name.comment }
            name.save
          end
        rescue Timeout::Error
          next
        end
      end
      DomainWatcherMailer.status_update(diff).deliver_later if diff.present?
    end
    WatchDomainsJob.set(wait: 20.minutes).perform_later
  end
  
end
