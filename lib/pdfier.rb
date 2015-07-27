class Pdfier
  
  def self.process(files, folder)
    pdf = CombinePDF.new
    pdf << CombinePDF.parse(files[:pdf][:user_info].tempfile.read)
    files[:html].keys.each do |name|
      send(name.to_sym, files[:html][name].tempfile, folder)
      pdf << CombinePDF.load(File.join Rails.root, 'public', 'tmp', folder, name + '.pdf')
    end
    (files[:pdf].keys - ['user_info']).each { |name| pdf << CombinePDF.parse(files[:pdf][name].tempfile.read) }
    pdf.save File.join(Rails.root, 'public', 'tmp', folder, 'report.pdf')
  end
  
  private
    
  def self.login_history(file, folder)
    page = Nokogiri::HTML file
    page.css('#searchFormDiv').remove
    page.css('#findLoginHistoryButton').remove
    2.times { page.css('.navHeader.fullWidth td:last-child').remove }
    page.css('#contentTable tbody tr').css('td:first-child div:last-child').remove
    page.css('#contentTable tbody tr').css('td:first-child div:first-child a.anchorLink').remove
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'login_history.pdf')
  end
    
  def self.change_log(file, folder)
    page = Nokogiri::HTML file
    page.css('#searchFormDiv').remove
    page.css('#findDomainsButton').remove
    2.times { page.css('.navHeader.fullWidth td:last-child').remove }
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'change_log.pdf')
  end
  
  def self.domain_list(file, folder)
    page = Nokogiri::HTML file
    page.css('#searchFormDiv').remove
    2.times { page.css('table.navHeader.fullWidth').css('td:last-child').remove }
    page.css('#contentTable').css('thead tr:first-child').remove
    page.css('#contentTable').css('thead tr:first-child th:first-child').remove
    2.times { page.css('#contentTable tbody tr:last-child').remove }
    page.css("td.noBorder").remove
    page.css("#contentTable tbody tr td:first-child").each do |td|
      td.css('div:last-child').remove
      td.next_element.css('div:last-child').remove
      td.next_element.css('a.anchorLink').remove
      td.next_element.next_element.css('a').remove
    end
    page.css("th[align='center'] img").each { |img| img.parent.content =  img.attribute('alt').value }
    page.css("td[align='center'] img").each { |img| img.ancestors('td').first.content = '✔' }
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'domain_list.pdf')
  end
    
  def self.order_list(file, folder)
    page = Nokogiri::HTML file
    page.css('form[name="frmCriteria"]').remove
    page.css('#paging').last.remove
    2.times { page.css('#paging div:last-child').remove }
    page.css('.myform').remove
    page.css('[name^="refundStatusDiv"]').each { |div| div.parent.remove }
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'order_list.pdf')
  end
    
  def self.transation_review(file, folder)
    page = Nokogiri::HTML file
    page.css('#searchFormDiv').remove
    page.css('#contentDiv div:first-child').remove
    2.times { page.css('.navHeader td:last-child').remove }
    page.css('input[type="image"]').remove
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'transation_review.pdf')
  end
    
  def self.push_history_to(file, folder)
    page = Nokogiri::HTML file
    page.css('#searchFormDiv').remove
    page.css('#findPushHistoryButton').remove
    2.times { page.css('.navHeader.fullWidth td:last-child').remove }
    page.css('#contentTable tr td:first-child').each do |td|
      td.css('div:last-child').remove
      td.next_element.css('div:last-child').remove
    end
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'push_history_to.pdf')
  end
  
  def self.push_history_from(file, folder)
    page = Nokogiri::HTML file
    page.css('#searchFormDiv').remove
    page.css('#findPushHistoryButton').remove
    2.times { page.css('.navHeader.fullWidth td:last-child').remove }
    page.css('#contentTable tr td:first-child').each do |td|
      td.css('div:last-child').remove
      td.next_element.css('div:last-child').remove
    end
    
    kit = PDFKit.new(page.to_html)
    kit.stylesheets << File.join(Rails.root, 'public', 'tmp', 'styles', 'layout.css')
    kit.to_file File.join(Rails.root, 'public', 'tmp', folder, 'push_history_from.pdf')
  end
  
end