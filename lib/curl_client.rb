class CurlClient
  
  def self.process_multiple(urls)
    easy_options, multi_options = { follow_location: true, useragent: "curb" }, { pipeline: true }
    result = []
    Curl::Multi.get(urls, easy_options, multi_options) do |easy|
      Retriable.retriable do
        values = { "URL"                => easy.url,
                   "Last Effective URL" => easy.last_effective_url,
                   "Response Code"      => easy.response_code
        }
        values.merge!({ 'Title' => easy.body_str.match(/<title>.+<\/title>/).to_s[7..-9].try(:force_encoding, 'utf-8') } ) if easy.body_str.present?
        easy.on_failure { values['Title'] = 'Failure!' }
        result << values
      end
    end
    result
  end
  
end