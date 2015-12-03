class HostingAbuseForm
  
  class DiscSpace
    
    include Virtus.model
  
    extend  ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Validations
    
    attribute :folders, String
    
    attr_accessor :service
    
    validates :folders, presence: true
    
  end
  
end