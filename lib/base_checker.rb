class BaseChecker

  def negative_test_host
    "example.com"
  end

  def valid?(resolver)
    !resolver.search(positive_test_host + "." + base_host, Net::DNS::A).answer.empty? && resolver.search(negative_test_host + "." + base_host, Net::DNS::A).answer.empty?
  end

  def initialize
    if valid?(Net::DNS::Resolver.new)
      @checker = Net::DNS::Resolver.new
    else
      nameservers, ips = [], []
      Net::DNS::Resolver.start(base_host, Net::DNS::NS).answer.each { |ns| nameservers << ns.value }
      nameservers.each { |ns| ips << Net::DNS::Resolver.start(ns, Net::DNS::A).answer.first.value }
      @checker = Net::DNS::Resolver.new(nameservers: ips)
      raise "Unable to initialize a #{type} checker" unless valid?(@checker)
    end
  end

  def listed?(domain)
    @checker.search("#{domain}.#{base_host}").answer.empty? ? false : true
  end

end