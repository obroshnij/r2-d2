class HostingAbuseCronJob < ActiveRecord::Base
  
  enum activity_type: [:too_many, :too_often]
  enum measure:       [:frequency_reduced, :amount_reduced, :other]
  
end