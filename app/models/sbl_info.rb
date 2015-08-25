require 'open-uri'

class SblInfo < ActiveRecord::Base
  
  def self.parse
    url = 'http://www.spamhaus.org/sbl/listings/namecheap.com'
    page = Nokogiri::HTML open(url)

    listings = page.css('table[border="0"][cellpadding="4"][cellspacing="0"]').map do |list|
      listing = {}
      listing[:sbl_id] = list.css('tr')[0].css('a.listmenu').first.text.match(/[[:digit:]]+/).to_s.to_i
      listing[:ip_range] = list.css('tr')[1].css('span.body').first.text
      listing[:date] = DateTime.parse list.css('tr')[2].css('span.body').first.text
      listing[:comment] = list.css('tr')[3].css('span.body').first.text.strip.gsub(/[[:blank:]]+/, ' ')
      listing[:rokso] = list.css('td')[1].attr('bgcolor') == '#ffcc00'
      listing
    end
  end
  
end