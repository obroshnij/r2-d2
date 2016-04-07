class Legal::Rbl::Checker::Skip
  
  def check ip_address, rbls
    rbls.map do |rbl|
      {
        name:   rbl.name,
        status: rbl.status.name,
        result: 'Skip',
        data:   { 'Reason' => "Don't know how to check this blacklist" }
      }
    end
  end
  
end