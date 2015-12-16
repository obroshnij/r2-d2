class HostingAbuseForm
  
  class CronJob
    
    include Virtus.model
  
    extend  ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Validations
    
    attribute :activity_type, String
    attribute :measure,       String, default: 'frequency_reduced'
    attribute :other_measure, String
    
    attr_accessor :service
    
    validates :activity_type, :measure, presence: true
    validates :other_measure, presence: true, if: :other_measure_required?
    
    def run_conditional(method_name_value_or_proc)
      method_name_value_or_proc == :other_measure_required? || supers
    end
    
    def other_measure_required?
      self.measure == 'other'
    end
    
    MEASURES = {
      frequency_reduced: "Frequency of an active cron was reduced",
      amount_reduced:    "Amount of simultaneous crons was reduced",
      other:             "Other"
    }
    
    def activity_types
      HostingAbuseCronJob.activity_types.map { |t| [t.first.humanize, t.first] }
    end
    
  end
  
end