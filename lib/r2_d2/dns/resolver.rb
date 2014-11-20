module R2D2

  module DNS

    class Resolver

      attr_reader :type

      # Initialize a Resolver instance
      def initialize(options = {})
        @resolver = case options[:type].try(:to_sym)
          when :default; Net::DNS::Resolver.new
          when :google; Net::DNS::Resolver.new(nameservers: ["8.8.8.8", "8.8.4.4"])
          when :open; Net::DNS::Resolver.new(nameservers: ["208.67.222.222", "208.67.220.220"])
          when :custom; Net::DNS::Resolver.new(nameservers: options[:nameservers])
          else; raise ArgumentError, "Invalid nameserver type: #{options[:type].inspect}"
        end
        @type = options[:type].to_s.camelize
      end

      # Dig specified host name, A record by default
      # Returns an array of host records
      def dig(options = {})
        raise ArgumentError, "Host is required" unless options[:host]
        options[:record] = :a unless options[:record]
        @resolver.search(options[:host], R2D2::DNS.record_type(options[:record])).answer.each_with_object(Array.new) { |answer, array| array << answer.value }
      rescue Net::DNS::Resolver::NoResponseError
        ["No Response"]
      end

    end

  end

end