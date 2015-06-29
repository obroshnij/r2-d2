module DNS
  class DBL < SpamBase

    def type
      :dbl
    end

    private

    def positive_test_host
      "dbltest.com"
    end

    def base_host
      "dbl.spamhaus.org"
    end

  end
end