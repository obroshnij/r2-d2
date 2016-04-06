class Legal::Rbl::Checker::Skip
  
  def check ip_address, rbls
    rbls.map do |rbl|
      {
        name:   rbl.name,
        result: 'Skip',
        data:   { 'Error' => "Don't know how to check this blacklist" }
      }
    end
  end
  
end