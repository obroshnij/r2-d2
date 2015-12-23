class HostingAbuseInfo
  
  class Suggestion
    
    SUGGESTIONS = {
      six:         '6 Hours',
      twelve:      '12 Hours',
      twenty_four: '24 Hours',
      to_suspend:  'To Suspend',
      suspended:   'Already Suspended'
    }
    
    def self.all
      HostingAbuseInfo.suggestions.map do |value, id|
        { value: value, name: SUGGESTIONS[value.to_sym] }
      end
    end
    
  end
  
end