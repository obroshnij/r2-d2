module WhoisParser
  class INFO < Base
    
    def availability_pattern
      Regexp.new 'NOT FOUND'
    end
    
  end
end