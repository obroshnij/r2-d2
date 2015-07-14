module WhoisParser
  class NET < Base
    
    def availability_pattern
      Regexp.new 'No match for domain "' + @domain_name.upcase + '".'
    end
    
  end
end