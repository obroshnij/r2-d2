class CurlClient
  
  def self.process_multiple(urls)
    easy_options, multi_options = { follow_location: true, useragent: "curb" }, { pipeline: true }
    result = []
    Curl::Multi.get(urls, easy_options, multi_options) do |easy|
      Retriable.retriable do
        result << { "URL"                => easy.url,
                    "Last Effective URL" => easy.last_effective_url,
                    "Response Code"      => easy.response_code,
                    "Title"              => easy.body_str.match(/<title>.+<\/title>/).to_s[7..-9].force_encoding('utf-8') }
      end
    end
    result
  end
  
end