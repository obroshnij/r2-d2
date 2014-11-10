class DblChecker < BaseChecker

  def type
    "DBL"
  end

  def base_host
    "dbl.spamhaus.org"
  end

  def positive_test_host
    "dbltest.com"
  end

end