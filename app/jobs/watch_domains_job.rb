class WatchDomainsJob < ActiveJob::Base
  queue_as :whois

  def perform
    names = Domains::WatchedDomain.all
    diff = {}
    if names.present?
      names.each do |name|
        begin
          unless name.status.sort == name.new_status.sort
            diff[name.email] ||= {}
            diff[name.email][name.name] = { status: [name.status.join(', '), name.new_status.join(', ')], comment: name.comment }
            name.save
          end
        rescue Timeout::Error
          next
        end
      end
      diff.each do |email, diff_val|
        DomainWatcherMailer.status_update(email, diff_val).deliver_later if diff.present?
      end
    end
  ensure
    WatchDomainsJob.set(wait: 20.minutes).perform_later
  end

end
