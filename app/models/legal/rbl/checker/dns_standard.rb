class Legal::Rbl::Checker::DnsStandard
  
  def check ip_address, rbls
    rbls.map do |rbl|
      {
        name:   rbl.name,
        result: 'Listed',
        data:   { 'Type' => 'A', 'TTL' => '128' }
      }
    end
  end
  
end