module DNS
  class SpamBase

    def self.valid_nameserver? nameservers
      resolver = DNS::Resolver.new type: :custom, nameservers: [nameservers].flatten
      positive = resolver.dig("#{positive_test_host}.#{base_host}",  record: :a)
      negative = resolver.dig("#{negative_test_host}.#{base_host}", record: :a)
      return false if positive.first == "No Response" || negative.first == "No Response"
      positive.present? && negative.blank?
    end

    def self.negative_test_host
      "example.com"
    end

    # def self.check_multiple domains
    #   threads = [DNS::DBL.new, DNS::SURBL.new].map do |checker|
    #     Thread.new(checker, domains) do |checker, domains|
    #       domains.each { |domain| domain.extra_attr[checker.type] = checker.listed? domain.name }
    #     end
    #   end.each(&:join)
    # end

    def self.check_multiple domains
      classes = [DNS::DBL, DNS::SURBL]
      domains.map do |domain|
        Thread.new(domain, classes) do |domain, classes|
          checkers = classes.map(&:new)
          checkers.each { |checker| domain.extra_attr[checker.type] = checker.listed?(domain.name) }
        end
      end.each(&:join)
    end

    def initialize
      initialize_resolvers
    end

    def listed? domain
      get_a_record(domain).present?
    end

    private

    attr_accessor :resolvers

    def nameservers
      @nameservers ||= get_nameservers
    end

    def get_nameservers
      path = File.join(File.dirname(__FILE__), "#{type}_ns.json")
      File.open(path, "r") { |f| JSON.parse f.read }
    end

    def initialize_resolvers
      raise "Unable to initialize a #{type.to_s.upcase} checker" if nameservers.blank?
      @resolvers = nameservers.map do |ns|
        {
          namserver: ns,
          resolver:  DNS::Resolver.new(type: :custom, nameservers: ns)
        }
      end
    end

    def get_a_record domain
      raise "Unable to get response from #{type.to_s.upcase} DNS servers, try again" if resolvers.blank?

      ns = resolvers.sample
      record = ns[:resolver].dig("#{domain}.#{self.class.base_host}", record: :a).first

      if record == "No Response"
        self.resolvers = resolvers.delete_if { |r| r[:nameserver] == ns[:nameserver] }
        return get_a_record(domain)
      end

      record
    end

  end
end
