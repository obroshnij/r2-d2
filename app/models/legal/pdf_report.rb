class Legal::PdfReport < ActiveRecord::Base
  self.table_name = 'legal_pdf_reports'

  store_accessor :content, :pages, :order

  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :edited_by,  class_name: 'User', foreign_key: 'edited_by_id'

  validates :username, presence: true

  before_create do
    self.username   = username.strip.downcase
    self.expires_on = Date.current + 1.month
  end

  def render_pdf page_ids = nil
    page_ids ||= pages.keys
    page_ids.sort_by! { |id| order.index(id) || 99999 }
    pdf = Legal::Pdf.new
    page_ids.each { |id| pdf.add_report_page pages[id] }
    pdf.render
  end

  def pdf_name
    "#{username} - #{created_at.strftime('%b/%d/%Y')}.pdf"
  end

  def merge ids
    data = ids.sort.map { |id| pages[id]['data'] }.flatten
    self.pages[ids.last]['data'] = data
    self.pages = pages.except *(ids - [ids.last])
    save
  end

  def delete_page id
    self.pages = pages.except id
    save
  end

end
