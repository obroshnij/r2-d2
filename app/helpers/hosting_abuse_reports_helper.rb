module HostingAbuseReportsHelper
  
  def hidden_if_blank(value)
    value.blank? ? "display:none;" : "display:block;"
  end
  
end