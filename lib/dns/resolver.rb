require 'thread/pool'

module DNS
  class Resolver

    NAMESERVERS = {
      google:   ["8.8.8.8",        "8.8.4.4"],
      open:     ["208.67.222.222", "208.67.220.220"],
      verisign: ["64.6.64.6",      "64.6.65.6"],
      dyn:      ["216.146.35.35",  "216.146.36.36"],
      comodo:   ["8.26.56.26",     "8.20.247.20"]
    }

    attr_reader :type

    def initialize options = {}
      options[:type] ||= :google
      nameservers = get_nameservers options

      @resolver = Net::DNS::Resolver.new nameservers: nameservers
      @type     = options[:type].to_s.camelize

      @resolver.tcp_timeout, @resolver.udp_timeout = 2, 2
    end

    def dig host, options = {}
      options[:record] = :a if options[:record].blank?
      @resolver.search(host, DNS.record_type(options[:record])).answer.map { |answer| answer.value.chomp(".") }
    rescue Net::DNS::Resolver::NoResponseError
      ["No Response"]
    end

    def self.dig_multiple domains, options = {}
      pool = Thread.pool 100
      domains.each do |domain|
        pool.process(domain) do |domain|
          resolver = DNS::Resolver.new type: options[:type]
          domain.extra_attr[:host_records] ||= {}
          options[:records].each do |record|
            domain.extra_attr[:host_records][record] = resolver.dig domain.name, record: record
          end
        end
      end
      pool.shutdown
    end

    private

    def get_nameservers options
      type = options[:type].to_sym
      return options[:nameservers] if type == :custom
      raise ArgumentError, "Invalid nameserver type: #{type}" unless NAMESERVERS[type]
      NAMESERVERS[type]
    end

  end
end
