class HostingAbuseResource
  
  class Measure
    
    MEASURES = {
      frequency_reduced: 'Frequency of an active cron was reduced',
      amount_reduced:    'Amount of simultaneous crons was reduced',
      other:             'Other'
    }
    
    def self.all
      HostingAbuseResource.measures.map do |value, id|
        { value: value, name: MEASURES[value.to_sym] }
      end
    end
    
  end
  
end