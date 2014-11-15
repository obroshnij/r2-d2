module R2D2

  module DNS

    # Abstract class, subclassed by DBL and SURBL classes
    class DblSurbl

      def initialize
        resolver = R2D2::DNS::Resolver.new(type: :default)
        if valid? resolver
          @checker = resolver
        else
          nameservers = resolver.dig(host: base_host, record: :ns)
          ips = nameservers.each_with_object(Array.new) { |ns, array| array << resolver.dig(host: ns, record: :a).first }
          @checker = R2D2::DNS::Resolver.new(type: :custom, nameservers: ips.compact)
          raise "Unable to initialize a #{type} checker" unless valid? @checker
        end
      end

      def listed?(domain)
        @checker.dig(host: "#{domain}.#{base_host}", record: :a).empty? ? false : true
      end

      # Child classes must override this method
      def type() nil end

      private

      def valid?(resolver)
        !resolver.dig(host: positive_test_host + "." + base_host, record: :a).empty? && resolver.dig(host: negative_test_host + "." + base_host, record: :a).empty?
      end

      def negative_test_host() "example.com" end

      # The methods below must be overriden by child classes
      
      def positive_test_host() nil end
      
      def base_host() nil end

    end

  end

end