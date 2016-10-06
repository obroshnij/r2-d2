class Tools::DataSearch

  TLD_REGEX    = /(?:\.[a-z]+)+(?:--[a-z0-9]+)?/i
  IP_REGEX     = /\d+\.\d+\.\d+\.\d+/
  EMAIL_REGEX  = /[a-z0-9\.!#$%&'*+-\/=?_|{}~`^]+@(?:(?>[a-z0-9]+[a-z0-9\-]*[a-z0-9]+|[a-z0-9]*)\.)+[a-z]+(?:--[a-z0-9]+)?/i
  TICKET_REGEX = /[a-z]{3}\-[0-9]{3}\-[0-9]{5}/i

  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :query, :object_type, :items, :internal_items, :duplicates, :tlds

  validates :query, presence: true
  validates :object_type, inclusion: { in: ['domain', 'host', 'tld', 'ip_v4', 'email', 'kayako_ticket'] }

  def initialize query, object_type = 'domain', internal = 'remove', sort = 'none'
    @query, @object_type, @internal, @sort = query, object_type, internal, sort
    @internal_items, @duplicates, @tlds = { matched: [], wildcard: [] }, {}, {}

    @items = parse_items(@query) if valid?
    sort_items!                  if valid?
    search_internal_domains!     if valid? && ['domain', 'host', 'email'].include?(@object_type)
    clear_duplicates!            if valid? && ['domain', 'host'].include?(@object_type)
    count_tlds!                  if valid? && ['domain', 'host'].include?(@object_type)
  end

  private

  def sort_items!
    @items.sort_by! { |i| DomainName.new(i).tld } if @sort == 'tld'
    @items.sort!                                  if @sort == 'alphabetically'
  end

  def count_tlds!
    @items.map { |i| DomainName.new(i) }.each do |d|
      @tlds[d.tld] ||= 0
      @tlds[d.tld]  += 1
    end
  end

  def clear_duplicates!
    items = @items.map &:downcase
    @duplicates.keep_if { |k, v| items.include? k }
  end

  def search_internal_domains!
    domains, wildcards = get_domains_and_wildcards

    @items = @items.map do |item|
      if internal?(item, domains)
        update_internal_items(:matched, item)
        @internal == 'remove' ? nil : item.upcase

      elsif wildcard?(item, wildcards)
        update_internal_items(:wildcard, item)
        @internal == 'remove' ? nil : item.upcase

      else
        item
      end
    end.compact
  end

  def get_domains_and_wildcards
    domains, wildcards = [], []

    Tools::InternalDomain.all.each do |domain|
      name = domain.name
      begin
        dn = DomainName.new(name)
        domains << dn
      rescue ArgumentError
        wildcards << regexp_from_name(name)
      end
    end

    [domains, wildcards]
  end

  def regexp_from_name name
    Regexp.new name.gsub('.', '\.').gsub('%', '.*')
  end

  def internal? item, domains
    send "internal_#{@object_type}?", item, domains
  end

  def internal_domain? item, domains
    item_domain = DomainName.new(item)

    domains.find do |domain|
      domain.tld == item_domain.tld && domain.sld == item_domain.sld
    end.present?
  end

  def internal_host? item, domains
    internal_domain? item, domains
  end

  def internal_email? item, domains
    internal_domain? item.split('@').last, domains
  end

  def wildcard? item, wildcards
    send "wildcard_#{@object_type}?", item, wildcards
  end

  def wildcard_domain? item, wildcards
    wildcards.find { |wildcard| wildcard =~ item }.present?
  end

  def wildcard_host? item, wildcards
    item_domain = DomainName.new item
    wildcard_domain? "#{item_domain.sld}.#{item_domain.tld}", wildcards
  end

  def wildcard_email? item, wildcards
    item_domain = DomainName.new item.split('@').last
    wildcard_domain? "#{item_domain.sld}.#{item_domain.tld}", wildcards
  end

  def update_internal_items type, item
    @internal_items[type] << item
  end

  def parse_items query
    send "parse_#{@object_type}", query
  end

  def parse_domain query
    domains = DomainName.parse_multiple(query, remove_subdomains: true)
    domains.each { |d| @duplicates[d.name] = d.extra_attr[:occurrences_count] if d.extra_attr[:occurrences_count] > 1 }
    domains.map(&:name)
  end

  def parse_host query
    domains = DomainName.parse_multiple(query, remove_subdomains: false)
    domains.each { |d| @duplicates[d.name] = d.extra_attr[:occurrences_count] if d.extra_attr[:occurrences_count] > 1 }
    domains.map(&:name)
  end

  def parse_tld query
    query.scan(TLD_REGEX).select do |tld|
      PublicSuffix.valid? SimpleIDN.to_unicode(tld)
    end.map do |tld|
      '.' + SimpleIDN.to_ascii(PublicSuffix.parse(SimpleIDN.to_unicode(tld)).tld)
    end.uniq
  end

  def parse_ip_v4 query
    query.scan(IP_REGEX).select { |ip| IPAddress.valid?(ip) }
  end

  def parse_email query
    query.scan(EMAIL_REGEX).map(&:downcase).uniq.map do |email|
      PublicSuffix.valid?(SimpleIDN.to_unicode(email.split('@').last)) ? email : nil
    end.compact
  end

  def parse_kayako_ticket query
    query.scan(TICKET_REGEX).uniq
  end

end
