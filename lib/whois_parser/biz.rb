module WhoisParser
  class BIZ < Base
    
    def availability_pattern
      Regexp.new 'Not found: ' + @domain_name
    end
    
  end
end