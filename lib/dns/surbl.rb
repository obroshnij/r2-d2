module DNS
  class SURBL < SpamBase

    def type
      :surbl
    end

    private

    def positive_test_host
      "test.surbl.org"
    end

    def base_host
      "multi.surbl.org"
    end

  end
end