class SurblChecker < BaseChecker

  def type
    "SURBL"
  end

  def base_host
    "multi.surbl.org"
  end

  def positive_test_host
    "test.surbl.org"
  end

end