class ManagerToolsController < ApplicationController
  
  before_action :authenticate_user!
  authorize_resource class: false
  
  def monthly_reports
  end
  
  def generate_monthly_reports
    sheet = Roo::Excelx.new(params[:sheet].path, nil, :ignore)
    sheet.default_sheet = sheet.sheets.last
    array = sheet.to_a.delete_if { |el| el.compact.count < 4 }
    array[0][0] = "Name"

    array.flatten.each do |el|
      unless el.nil?
        el.to_s.gsub!(/[\n]/, " ")
        el.strip! unless el.is_a? Float
      end
    end
    
    @month = Date.parse(sheet.sheets.last).strftime("%B %Y")
    @norm = params[:norm].blank? ? "NO ONE KNOWS HOW MANY" : params[:norm]
    @employees = (array - [array.first]).map do |row|
      hash = {}
      array.first.each_with_index do |key, index|
        hash[key] = format_field(row[index]) unless row[index].nil? || row[index].blank?
      end
      hash
    end
    render action: :monthly_reports
  rescue Exception => ex
    flash.now[:alert] = "#{ex.class}: #{ex.message}"
    render action: :monthly_reports
  end
  
end