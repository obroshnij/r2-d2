module DNS
  class SpamBase
    
    def initialize
      resolver = DNS::Resolver.new(type: :default)
      if valid? resolver
        @checker = resolver
      else
        nameservers = resolver.dig(base_host, record: :ns)
        ips = nameservers.map { |ns| resolver.dig(ns, record: :a).first }
        @checker = DNS::Resolver.new(type: :custom, nameservers: ips.compact)
      end
      raise "Unable to initialize a #{type.to_s.upcase} checker" unless valid? @checker
    end

    def listed?(domain)
      @checker.dig(domain + "." + base_host, record: :a).present?
    end
    
    def self.check_multiple(domains)
      threads = [DNS::DBL.new, DNS::SURBL.new].map do |checker|
        Thread.new(checker, domains) do |checker, domains|
          domains.each { |domain| domain.extra_attr[checker.type] = checker.listed? domain.name }
        end
      end.each(&:join)
    end

    def type
      nil
    end

    private

    def valid?(resolver)
      resolver.dig(positive_test_host + "." + base_host, record: :a).present? && resolver.dig(negative_test_host + "." + base_host, record: :a).blank?
    end

    def negative_test_host
      "example.com"
    end
    
    def positive_test_host
      nil
    end
    
    def base_host
      nil
    end
    
  end
end