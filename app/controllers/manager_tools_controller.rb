class ManagerToolsController < ApplicationController
  
  before_action :authenticate_user!
  authorize_resource class: false
  
  def monthly_reports
  end
  
  def generate_monthly_reports
    raise ArgumentError, "No file selected" if (!params[:file] && !params[:excel_hash])
    if params[:file]
      file = Roo::Excelx.new(params[:file].path, nil, :ignore)
      excel_hash = {}
      file.sheets.each_with_index do |sheet, index|
        file.default_sheet = file.sheets[index]
        excel_hash[sheet] = file.to_a.delete_if { |el| el.compact.count < 3 }
        excel_hash[sheet][0][0] = "Name"
      end
      @excel_hash = excel_hash.to_json
      @sheets = excel_hash.keys
      @date = begin
        Date.parse(@sheets.last)
      rescue
        (Date.today - 1.month)
      end
    else
      excel_hash = JSON.parse params[:excel_hash]
      array = excel_hash[params[:sheet]]
      array.flatten.each do |el|
        unless el.nil?
          el.to_s.gsub!(/[\n]/, " ")
          el.strip! unless el.is_a? Float
        end
      end
      @month = Date.new(params[:date]["year"].to_i, params[:date]["month"].to_i).strftime("%B %Y")
      @norm = params[:norm].blank? ? "NO ONE KNOWS HOW MANY" : params[:norm]
      @employees = (array - [array.first]).map do |row|
        hash = {}
        array.first.each_with_index do |key, index|
          hash[key] = format_field(row[index]) unless row[index].nil? || row[index].blank?
        end
        hash
      end

    end
    render action: :monthly_reports
  rescue Exception => ex
    flash.now[:alert] = "#{ex.class}: #{ex.message}"
    render action: :monthly_reports
  end
  
end