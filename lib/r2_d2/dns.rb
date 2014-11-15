module R2D2

  module DNS

    def self.record_type(record)
      record_type = case record.try(:to_sym)
        when :a; Net::DNS::A
        when :aaaa; Net::DNS::AAAA
        when :cname; Net::DNS::CNAME
        when :mx; Net::DNS::MX
        when :txt; Net::DNS::TXT
        when :ns; Net::DNS::NS
        when :ptr; Net::DNS::PTR
        else; raise ArgumentError, "Invalid record type: #{record.inspect}"
      end
    end

  end

end