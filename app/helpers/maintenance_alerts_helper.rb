module MaintenanceAlertsHelper

  # Parse eNom maintenance alerts from http://www.enom.com/registrynews.asp
  def parse_alerts
    alerts = []
    maintenance_page = Nokogiri::HTML(open("http://www.enom.com/registrynews.asp"))
    maintenance_page.css('div.sCnt3.sFL').css('table').each do |table|
      alert = {}
      # Parse TLD (the left column)
      alert[:tlds] = "." + table.css('tbody').css('tr').css('td')[0].text.upcase
      # Parse message (the right column)
      alert[:message] = table.css('tbody').css('tr').css('td')[1].text.gsub(/(\r?\n){3,}/, '\1\1')
      # Extract :tlds from the message if needed
      alert[:tlds] = /.+and\s\.\w+/.match(alert[:message]).to_s if alert[:message] =~ /and\s\.\w+/
      # Remove :tlds from the message if needed
      alert[:message].gsub!(/.+and\s\.\w+/, '')
      # Extract the timeframe from the message
      # alert[:timeframe] = /\w+\s\d+,\s\d{4}?.+/.match(alert[:message]).to_s
      alert[:timeframe] = /\w+\s\d+.+/.match(alert[:message]).to_s
      # Remove the time frame from the message
      alert[:message].gsub!(/.+\w+\s\d+,\s\d{4}?.+\n/, '')
      # Remove extra spaces from the message
      alert[:message] = alert[:message].gsub(/(\r?\n){3,}/, '\1\1').strip
      alerts << alert
      break if table.next_element.text == "Product Maintenance Schedule"
    end
    alerts
  end

  def alert_id(alert)
    alert[:tlds].split.first.scan(/\w/).join + alert[:timeframe].split(' (').first.scan(/\w/).join
  end

  def post_id(alert)
    alert_id(alert) + "statusPost"
  end

  def extract_date(str)
    /\w+\s\d+\w?\w?,?\s\d{4}?/.match(str).to_s
  end

  def extract_time(str)
    /\d?\d:\d\d\s?[AMP]{0,2}/.match(str).to_s
  end

  def start_pacific(str)
    string = str.split("Pacific").first.split(" - ").first
    Time.zone = extract_time(string).blank? ? "UTC" : "Pacific Time (US & Canada)"
    Time.zone.parse("#{extract_date(string)} #{extract_time(string)}")
  end

  def end_pacific(str)
    string = str.split("Pacific").first.split(" - ").last
    date = extract_date(string).blank? ? (start_pacific(str)).to_date.to_s : extract_date(string)
    Time.zone = start_pacific(str).utc? ? "UTC" : "Pacific Time (US & Canada)"
    result = Time.zone.parse("#{date} #{extract_time(string)}")
    result >= start_pacific(str) ? result : result + 1.day
  end

  def start_utc(str)
    string = str.split("Pacific").last.split(" - ").first
    date = extract_date(string).blank? ? (start_pacific(str)).to_date.to_s : extract_date(string) + " " + (start_pacific(str)).year.to_s
    Time.zone = "UTC"
    result = Time.zone.parse("#{date} #{extract_time(string)}")
    result.month == 1 && (start_pacific(str)).month == 12 ? result + 1.year : result
  end

  def end_utc(str)
    string = str.split("Pacific").last.split(" - ").last
    date = extract_date(string).blank? ? (start_utc(str)).to_date.to_s : extract_date(string)
    Time.zone = "UTC"
    result = Time.zone.parse("#{date} #{extract_time(string)}")
    result >= start_utc(str) ? result : result + 1.day
  end

  def update_alert(alert)
    alert[:start_pacific] = start_pacific(alert[:timeframe])
    alert[:end_pacific] = end_pacific(alert[:timeframe])
    alert[:start_utc] = start_utc(alert[:timeframe])
    alert[:end_utc] = end_utc(alert[:timeframe])
  end

  def valid?(alert)
    return false unless alert[:start_pacific].in_time_zone("UTC") == alert[:start_utc]
    return false unless alert[:end_pacific].in_time_zone("UTC") == alert[:end_utc]
    return false unless alert[:end_pacific] - alert[:start_pacific] == alert[:end_utc] - alert[:start_utc]
    true
  end

  def permanent?(alert)
    alert[:start_utc] == alert[:end_utc] ? true : false
  end

  def timeframes(alert)
    timeframes = {}
    if permanent?(alert)
      timeframes["UTC"] = alert[:start_utc].strftime("Effective %B %-d, %Y (%A)")
    else
      timeframes["Pacific Time"] = alert[:start_pacific].strftime("%B %-d, %Y (%A) %I:%M %p - ")
      timeframes["Pacific Time"] += alert[:start_pacific].day < alert[:end_pacific].day ? alert[:end_pacific].strftime("%B %-d, %I:%M %p %Z") : alert[:end_pacific].strftime("%I:%M %p %Z")
      start_est, end_est = alert[:start_utc].in_time_zone("Eastern Time (US & Canada)"), alert[:end_utc].in_time_zone("Eastern Time (US & Canada)")
      timeframes["Eastern Time"] = start_est.strftime("%B %-d, %Y (%A) %I:%M %p - ")
      timeframes["Eastern Time"] += start_est.day < end_est.day ? end_est.strftime("%B %-d, %I:%M %p %Z") : end_est.strftime("%I:%M %p %Z")
      timeframes["UTC"] = alert[:start_utc].strftime("%B %-d, %Y (%A) %H:%M - ")
      timeframes["UTC"] += alert[:start_utc].day < alert[:end_utc].day ? alert[:end_utc].strftime("%B %-d, %H:%M %Z") : alert[:end_utc].strftime("%H:%M %Z")
      start_ua, end_ua = alert[:start_utc].in_time_zone("Kyiv"), alert[:end_utc].in_time_zone("Kyiv")
      timeframes["UA Time"] = start_ua.strftime("%B %-d, %Y (%A) %H:%M - ")
      timeframes["UA Time"] += start_ua.day < end_ua.day ? end_ua.strftime("%B %-d, %H:%M %Z") : end_ua.strftime("%H:%M %Z")
    end
    timeframes
  end

  def post_timeframes(alert)
    timeframes = ["", ""]
    start_est, end_est = alert[:start_utc].in_time_zone("Eastern Time (US & Canada)"), alert[:end_utc].in_time_zone("Eastern Time (US & Canada)")
    start_utc, end_utc = alert[:start_utc], alert[:end_utc]
    timeframes[0] = start_est.strftime("%B %-d, %Y (%A) %I:%M %p - ")
    # Starts and ends on the same day in both timezones
    if start_est.day == end_est.day && start_utc.day == end_utc.day && start_est.day == start_utc.day
      timeframes[0] += end_est.strftime("%I:%M %p %Z ") + start_utc.strftime("(%H:%M - ") + end_utc.strftime("%H:%M %Z)")
      timeframes[1] = start_utc.strftime("%B %-d")
    # EST and UTC both start on the same day, both end on the next one
    elsif start_est.day == start_utc.day && end_est.day == end_utc.day && start_utc.day < start_utc.day
      timeframes[0] += end_est.strftime("%B %-d, %I:%M %p %Z ") + start_utc.strftime("(%B %-d, %H:%M - ") + end_utc.strftime("%B %-d, %H:%M %Z)")
      timeframes[1] = start_utc.strftime("%B %-d - ") + end_utc.strftime("%-d")
    # EST starts and ends on the same day, UTC starts and ends on the next one
    elsif start_est.day == end_est.day && start_utc.day == end_utc.day && start_est.day < start_utc.day
      timeframes[0] += end_est.strftime("%I:%M %p %Z ") + start_utc.strftime("(%B %-d, %H:%M - ") + end_utc.strftime("%H:%M %Z)")
      timeframes[1] = start_est.strftime("%B %-d (%Z) / ") + start_utc.strftime("%B %-d (%Z)")
    # EST starts and ends on the same day, UTC starts on one day but ends on the next one
    elsif start_est.day == end_est.day && start_est.day == start_utc.day && start_utc.day < end_utc.day
      timeframes[0] += end_est.strftime("%I:%M %p %Z ") + start_utc.strftime("(%B %-d, %H:%M - ") + end_utc.strftime("%B %-d, %H:%M %Z)")
      timeframes[1] = start_est.strftime("%B %-d (%Z) / ") + start_utc.strftime("%B %-d - ") + end_utc.strftime("%-d (%Z)")
    # EST starts on one day and ends on the next one, UTC both starts and ends on the second day
    elsif start_est.day < end_est.day && end_est.day == start_utc.day && start_utc.day == end_utc.day
      timeframes[0] += end_est.strftime("%B %-d, %I:%M %p %Z ") + start_utc.strftime("(%B %-d, %H:%M - ") + end_utc.strftime("%H:%M %Z)")
      timeframes[1] = start_est.strftime("%B %-d - ") + end_est.strftime("%-d (%Z) / ") + start_utc.strftime("%B %-d (%Z)")
    end
    timeframes.each { |item| item.gsub!("UTC", "GMT") }
    timeframes
  end

  def post_title(alert)
    "#{alert[:tlds]} Domains: Scheduled Registry Maintenance - #{post_timeframes(alert)[1]}"
  end

  def tlds(string)
    tlds = string.gsub(' and ', ', ').split(', ')
    return "<b>#{tlds.first}</b>" if tlds.count == 1
    return "<b>#{tlds.first}</b> and <b>#{tlds.last}</b>" if tlds.count == 2
    "<b>#{tlds[0..-2].join(', ')}</b> and <b>#{tlds.last}</b>"
  end

  def post_content(alert)
    "Dear Customers,\n\nThis is to let you know that on <b>#{post_timeframes(alert)[1]}</b> the registry of #{tlds(alert[:tlds])} domains will be processing a scheduled maintenance.\n\nThe time frame for the maintenance is as follows:\n\n<b>#{post_timeframes(alert)[0]}</b>\n\nDomain availability checks, registrations, renewals and updates will not be possible throughout the maintenance window. DNS and WHOIS services will continue to operate normally.\n\nPlease allow time until the maintenance is finished and then feel free to modify your existing #{tlds(alert[:tlds])} domains or register a new one.\n\nThank you for your patience and understanding.\n\nKind regards,\nNamecheap Support Team"
  end

end