class ManagerToolsController < ApplicationController
  
  before_action :authenticate_user!
  authorize_resource class: false
  
  def monthly_reports
  end
  
  def generate_monthly_reports
    raise ArgumentError, "No file selected" if (!params[:file] && !params[:excel_hash])
    if params[:file]
      excel_hash = parse_excel_file params[:file]
      @excel_hash = excel_hash.to_json
      @sheets = excel_hash.keys
      @date = begin
        Date.parse(@sheets.last)
      rescue
        (Date.today - 1.month)
      end
    else
      excel_hash = JSON.parse params[:excel_hash]
      excel_array = format_table_fields excel_hash[params[:sheet]]
      @employees = transform_excel_data_to_hash excel_array
      @month = Date.new(params[:date]["year"].to_i, params[:date]["month"].to_i).strftime("%B %Y")
    end
    render action: :monthly_reports
  rescue Exception => ex
    flash.now[:alert] = "#{ex.class}: #{ex.message}"
    render action: :monthly_reports
  end
  
  def welcome_emails
  end
  
  def generate_welcome_emails
    @people = params[:people].scan(/[0-9]+/).map do|id|
      url = Rails.application.secrets.staff_api_url + 'users/' + id + '?auth_token=' + Rails.application.secrets.staff_api_key
      user = JSON.parse Net::HTTP.get(URI(url))
      user['nc_email'] = user['email'].split('@').first + '@namecheap.com'
      user
    end
    render action: :welcome_emails
  end
  
end