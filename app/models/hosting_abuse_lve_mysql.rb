class HostingAbuseLveMysql < ActiveRecord::Base
  
  enum upgrade_suggestion: [:business_ssd, :vps_one, :vps_two, :vps_three, :dedicated]
  enum impact:             [:medium, :high, :extremely_high]
  
end