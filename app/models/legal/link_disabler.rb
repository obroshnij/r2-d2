class Legal::LinkDisabler

  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :links

  validates :links, presence: true

  def initialize(links, mode)
    @links = links.strip
    @mode = mode
    change_links if valid?
  end

  private

  def change_links
    array_links = @links.split("\n")

    @links = encode_links(URI.extract(@links)) if @mode == 'encode'
    @links = decode_links(array_links) if @mode == 'decode'
    @links = invert_links(array_links) if @mode == 'auto'

    errors.add(:links, 'no valid links found') if @links.empty?
  end

  def encode_links(arrays)
    result_array = []
    arrays.each do |link|
      link = URI.extract(link)[0]
      if link.scan(URI.regexp)[0].try(:first) == 'http' || link.scan(URI.regexp)[0].try(:first) == 'https'

        link.sub!('http', 'hxxp')
        link.sub!('://', ':// ')
        link.gsub!('.', ' [.] ')

        result_array << link
      end
    end
    result = result_array.reject{|i| !(i =~ URI::regexp)}
    result
  end

  def decode_links(arrays)
    result_array = []
    arrays.each do |link|
      link.gsub!(' ', '')

      link = rot13(link) if link =~ /^uggc/

      http = link.scan(URI.regexp)[0].try(:first)
      http.try(:last) == 's' ? link.sub!("#{http}", 'https') : link.sub!("#{http}", 'http')

      link.gsub!('[dot]', '.')
      link.gsub!('[.]', '.')
      result_array << link
    end
    result = result_array.reject{|i| !(i =~ URI::regexp)}
    result
  end

  def invert_links(arrays)
    http_count = arrays.map{|i| i.scan(URI.regexp)[0].try(:first)}.count('http')
    (http_count > (arrays.length / 2)) ? encode_links(arrays) : decode_links(arrays)
  end

  # https://en.wikipedia.org/wiki/ROT13
  def rot13 val
    val.tr "A-Ma-mN-Zn-z", "N-Zn-zA-Ma-m"
  end

end
