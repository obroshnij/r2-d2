class HostingAbuseDdos
  
  class BlockType
    
    BLOCK_TYPES = {
      :haproxy   => "HAProxy",
      :hablkctl  => "HAblkctl (Extended HAProxy)",
      :ip_tables => "IP Tables",
      :rule      => "Rule",
      :other     => "Other"
    }
    
    def self.all
      HostingAbuseDdos.block_types.map do |value, id|
        { value: value, name: BLOCK_TYPES[value.to_sym] }
      end
    end
    
  end
  
end