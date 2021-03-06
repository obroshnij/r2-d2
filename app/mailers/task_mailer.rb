class TaskMailer < ApplicationMailer

  def performance_issues_tracking(rows_need)
    @rows = rows_need
    mail(
      to:      ['nata@namecheap.com', 'richard.k@namecheap.com', 'sergey.s@namecheap.com', 'alina.b@namecheap.com', 'paul.r@namecheap.com', 'kate.sushkova@namecheap.com', 'anton.sheyko@namecheap.com', 'andrey.nesterenko@namecheap.com'],
      subject: "Checkout and Website Performance Issues Tracking - #{Date.today.strftime('%d %b %Y')}"
    )
  end
end
