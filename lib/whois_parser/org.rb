module WhoisParser
  class ORG < Base
    
    def availability_pattern
      Regexp.new 'NOT FOUND'
    end
    
  end
end