class HostingAbuseForm
  
  class LveMysql
    
    include Virtus.model
    
    extend  ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Validations
    
    attribute :resource_types,     Array[String]
    attribute :mysql_queries,      String
    attribute :lve_report,         String
    attribute :upgrade_suggestion, String
    attribute :impact,             String
    
    attr_accessor :service
    
    validates :upgrade_suggestion, :impact, :resource_types, presence: true
    
    RESOURCE_TYPES = {
      cpu:       "CPU Usage",
      memory:    "Memory Usage",
      entry:     "Entry Processes",
      io:        "Input/Output",
      mysql:     "MySQL Queries",
      processes: "Number of (simultanious) Processes Failed"
    }
    
    UPGRADE_SUGGESTIONS = {
      business_ssd: "Business SSD",
      vps_one:      "VPS 1 - Xen",
      vps_two:      "VPS 2 - Xen",
      vps_three:    "VPS 3 - Xen",
      dedicated:    "Dedicated Server"
    }
    
    def upgrade_suggestions
      HostingAbuseLveMysql.upgrade_suggestions.map { |s| [UPGRADE_SUGGESTIONS[s.first.to_sym], s.first] }
    end
    
    def impacts
      HostingAbuseLveMysql.impacts.map { |p| [p.first.humanize, p.first] }
    end
    
  end
  
end