module R2D2

  module DNS

    class SURBL < R2D2::DNS::DblSurbl

      def type() "SURBL" end

      private

      def positive_test_host() "test.surbl.org" end

      def base_host() "multi.surbl.org" end

    end

  end

end