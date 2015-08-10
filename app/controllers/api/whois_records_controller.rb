class Api::WhoisRecordsController < ApplicationController
  
  respond_to :json
  
  def index
    domains = DomainName.parse_multiple params[:names]
    Whois.lookup_multiple domains
    res = domains.map { |d| { name: d.name, record: d.whois.record, properties: format(d.whois.properties) } }
    respond_with res, status: 200
  end
  
  def show
    res = { record: Whois.lookup(name) }
    respond_with res, status: 200
  rescue => exception
    res = { error: exception.message, trace: exception.backtrace }
    respond_with res, status: 422
  end
  
  private
  
  def name
    params[:id].gsub('_', '.')
  end
  
  def format(properties)
    if properties.present?
      properties.each do |key, value|
        properties[key] = value.join("\n") if value.is_a?(Array)
        properties[key] = DateTime.parse(value).strftime('%d %b %Y') if key.to_s.include?('_date')
        properties[key] = "Yes" if value == true
        properties[key] = "No" if value == false
      end
    end
    properties
  end
  
end