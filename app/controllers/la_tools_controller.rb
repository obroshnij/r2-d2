class LaToolsController < ApplicationController

  before_action :authenticate_user!
  
  # Legal & Abuse > Spam
  def new
  end
  
  # Legal & Abuse > Spam, submit the form
  def parse
    hash = R2D2::Parser.parse_domains(params.permit(:text, :count_occurrences, :remove_subdomains))
    @occurrences_count = hash[:occurrences_count]
    @domains = hash[:domains]
    render action: :new
  end
  
  # Legal & Abuse > Spam, submit the form with CSV
  def append_csv
    domains_count = Hash[*params[:domains_count].split]
    csv = parse_domains_info(params[:domains_info].tempfile)
    data = Array.new
    csv.each do |line|
      hash = { domain_name: line[:domain_name], occurrences_count: domains_count[line[:domain_name]] }
      [:username, :full_name, :email_address].each { |option| hash[option] = line[option] }
      data << hash
    end
    
    data = dbl_surbl_bulk_check data
    data = epp_status_bulk_check data
    data = dns_bulk_check data
    data = internal_lists_bulk_check data
    data = suspension_bulk_check data
    
    current_user.reported_domains.all.delete_all unless current_user.reported_domains.blank?
    current_user.reported_domains.create data
    
    redirect_to action: :spam_result
  end
  
  # Legal & Abuse > Parsed Data
  def spam_result
    data = current_user.reported_domains.to_a
    respond_to do |format|
      format.csv { send_data generate_csv(data) }
      format.html do
        @spam_data_for_owners = transform_spam_data_for_owners data
      end
    end
  end
  
  # Legal & Abuse > DBL/SURBL Check
  def dbl_surbl
  end
  
  # Legal & Abuse > DBL/SURBL Check, submit the form
  def dbl_surbl_check
    checkers = [R2D2::DNS::DBL.new, R2D2::DNS::SURBL.new]
    domains = params[:query].downcase.split
    @result = domains.each_with_object(Array.new) do |domain, array|
      hash = Hash[:domain_name, domain]
      checkers.each { |checker| hash[checker.type.downcase.to_sym] = checker.listed?(domain) }
      hash[:blacklisted] = hash[:dbl] || hash[:surbl] ? true : false
      array << hash
    end
    @domains = domains.join("\n")
    render action: :dbl_surbl
  rescue Exception => ex
    flash.now[:alert] = "Error: #{ex.message}"
    render action: :dbl_surbl
  end

end