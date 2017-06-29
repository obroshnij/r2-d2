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

    def initialize
      raise "Unable to initialize a #{type.to_s.upcase} checker" if nameservers.blank?
      @checker = DNS::Resolver.new(type: :custom, nameservers: nameservers)
    end

    def listed? domain
      res = @checker.dig("#{domain}.#{self.class.base_host}", record: :a)
      res.present?
    end

    private

    def nameservers
      @nameservers ||= get_nameservers
    end

    def get_nameservers
      path = File.join(File.dirname(__FILE__), "#{type}_ns.json")
      File.open(path, "r") { |f| JSON.parse f.read }
    end

  end
end
