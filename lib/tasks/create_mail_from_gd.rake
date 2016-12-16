namespace :nc_performance do
  desc "Parse google drive and send letter"
  task notify: :environment do
    session = GoogleDrive.saved_session File.join(Rails.root, 'config', 'google_drive.json')
    doc = session.spreadsheet_by_key('1uyxGGP6YKc0uOIPRxGwPQLwcM4JUg-9SpeC8HN0JwSY')
    rows = doc.worksheets[0].rows

    rows_need = rows.drop(1).map { |r| r if r[0].present? && Date.strptime(r[0], "%m/%d/%Y").today? }.compact
    TaskMailer.performance_issues_tracking(rows_need).deliver
  end
end
