module WhoisParser
  class BZ < Base
    
    def availability_pattern
      Regexp.new 'NOT FOUND'
    end
    
  end
end