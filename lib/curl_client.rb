class CurlClient
  class << self

    def process_multiple urls
      urls.map { |url| process url }
    end

    def process url
      curl = Curl::Easy.new url

      curl.follow_location = true
      curl.useragent = "curb"
      curl.max_redirects = 20

      result = {}

      begin
        curl.perform
      rescue Exception => ex
        result['Error'] = ex.message
      ensure
        result['URL'] = to_utf8 curl.url
        result['Last Effective URL'] = to_utf8 curl.last_effective_url
        result['Response Code'] = curl.response_code
        result['Title'] = to_utf8 get_title(curl.body_str)
      end

      result
    end

    def get_title body_str
      return nil unless body_str.present?
      body_str.match(/<title>.+<\/title>/).to_s[7..-9].try(:force_encoding, 'utf-8')
    end

    def to_utf8 str
      str = str.force_encoding("UTF-8")
      return str if str.valid_encoding?
      str = str.force_encoding("BINARY")
      str.encode("UTF-8", invalid: :replace, undef: :replace)
    end

  end
end
