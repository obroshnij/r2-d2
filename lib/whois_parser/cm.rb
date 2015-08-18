module WhoisParser
  class CM < Base
    
    def status
      node('status') == ['No Object Found'] ? nil : super
    end
    
  end
end