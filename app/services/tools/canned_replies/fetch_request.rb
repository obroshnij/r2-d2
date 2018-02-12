class Tools::CannedReplies::FetchRequest
  attr_accessor :resource_path

  def self.call resource_path
    service = new resource_path
    service.send :perform
  end

  def initialize resource_path
    @resource_path = resource_path
  end

  private

  def perform
    fetch_resource
  end

  def sb_credentials
    Rails.application.secrets.sandbox_support
  end

  def fetch_resource
    http_client.request sb_get_request
  end

  def resource_url
    @url ||= URI.join(sb_credentials['url'], resource_path)
  end

  def http_client
    http = Net::HTTP.new(resource_url.host, resource_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def sb_get_request
    request = Net::HTTP::Get.new(resource_url.path)
    request.basic_auth(sb_credentials['auth']['login'], sb_credentials['auth']['pass'])
    request
  end

end
