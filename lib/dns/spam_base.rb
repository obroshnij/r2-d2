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

    def self.check_multiple domains
      threads = [DNS::DBL.new, DNS::SURBL.new].map do |checker|
        Thread.new(checker, domains) do |checker, domains|
          domains.each { |domain| domain.extra_attr[checker.type] = checker.listed? domain.name }
        end
      end.each(&:join)
    end

    # def self.check_multiple domains
    #   hosts = [DNS::DBL, DNS::SURBL].map do |klass|
    #     domains.map { |domain| "#{domain.name}.#{klass.base_host}" }
    #   end.flatten
    #
    #   uri = URI('https://dig-host.now.sh')
    #   req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    #   req.body = JSON.generate({ hosts: hosts })
    #   res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    #   data = JSON.parse res.body
    #
    #   [DNS::DBL, DNS::SURBL].each do |klass|
    #     domains.each do |domain|
    #       domain.extra_attr[klass.type] = data["#{domain.name}.#{klass.base_host}"].present?
    #     end
    #   end
    # end

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
          nameserver: ns,
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
