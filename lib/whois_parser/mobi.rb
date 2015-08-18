module WhoisParser
  class MOBI < Base
    
    def creation_date
      DateTime.parse(node('created on').last).to_s rescue nil
    end
    
    def updated_date
      DateTime.parse(node('last updated on').last).to_s rescue nil
    end
    
  end
end