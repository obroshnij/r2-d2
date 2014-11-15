module R2D2

  module DNS

    class DBL < R2D2::DNS::DblSurbl

      def type() "DBL" end

      private

      def positive_test_host() "dbltest.com" end

      def base_host() "dbl.spamhaus.org" end

    end

  end

end