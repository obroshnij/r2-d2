class DomainWatcherMailer < ApplicationMailer
  
  def status_update(diff)
    @diff = diff
    mail(to: 'nclead@namecheap.com', subject: 'R2-D2: Domain Status Updates')
  end
  
end