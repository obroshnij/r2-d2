class HostingAbuseDdos < ActiveRecord::Base
  
  enum block_type: [:haproxy, :hablkctl, :ip_tables, :rule, :other]

end