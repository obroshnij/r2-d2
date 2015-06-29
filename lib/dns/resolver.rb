module DNS
  class Resolver

    attr_reader :type

    def initialize(params = {})
      params[:type] = :default if params[:type].blank?
      @resolver = case params[:type].try(:to_sym)
        when :default; Net::DNS::Resolver.new
        when :google; Net::DNS::Resolver.new(nameservers: ["8.8.8.8", "8.8.4.4"])
        when :open; Net::DNS::Resolver.new(nameservers: ["208.67.222.222", "208.67.220.220"])
        when :custom; Net::DNS::Resolver.new(nameservers: params[:nameservers])
        else; raise ArgumentError, "Invalid nameserver type: #{params[:type].inspect}"
      end
      @type = params[:type].to_s.camelize
      @resolver.tcp_timeout, @resolver.udp_timeout = 2, 2
    end

    def dig(host, params = {})
      params[:record] = :a if params[:record].blank?
      @resolver.search(host, DNS.record_type(params[:record])).answer.map { |answer| answer.value.chomp(".") }
    rescue Net::DNS::Resolver::NoResponseError
      ["No Response"]
    end
    
    def self.dig_multiple(domains, params = {})
      threads = domains.map do |domain_name|
        Thread.new(domain_name) do |domain|
          resolver = DNS::Resolver.new type: params[:type]
          domain.extra_attr[:host_records] ||= {}
          params[:records].each do |record|
            domain.extra_attr[:host_records][record] = resolver.dig domain.name, record: record
          end
        end
      end.each(&:join)
    end

  end
end