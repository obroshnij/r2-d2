require 'thread/pool'

class Legal::Rbl::Checker::DnsStandard
  
  def check ip_address, rbls
    host_names = get_host_names ip_address, rbls
    dig_multiple host_names
    host_names.map { |host| host.extra_attr[:rbl] }
  end
  
  private
    
  def get_host_names ip_address, rbls
    reversed = ip_address.split('.').reverse.join('.')
    rbls.map do |rbl|
      domain = DomainName.new reversed + '.' + rbl.data['dns_zone']
      domain.extra_attr[:rbl] = {}
      domain.extra_attr[:rbl][:name]   = rbl.name
      domain.extra_attr[:rbl][:status] = rbl.status.name
      domain.extra_attr[:rbl][:data]   = {}
      domain
    end
  end
  
  def dig_multiple hosts
    pool = Thread.pool 100
    hosts.each do |host|
      pool.process(host) { |host| dig host }
    end
    pool.shutdown
  end
  
  def dig host
    resolver = Net::DNS::Resolver.new
    dig_a   host, resolver
    dig_txt host, resolver
  end
  
  def dig_a host, resolver
    a_record = resolver.search(host.name, Net::DNS::A).answer.first
    host.extra_attr[:rbl][:result] = a_record.present? ? 'Listed' : 'Not Listed'
    
    if a_record.present?
      host.extra_attr[:rbl][:data]['Query'] = a_record.name
      host.extra_attr[:rbl][:data]['A Record'] = a_record.value
      host.extra_attr[:rbl][:data]['TTL'] = a_record.ttl
    end
  
  rescue Exception => exception
    host.extra_attr[:rbl][:result] = 'Failure'
    host.extra_attr[:rbl][:data]['Error']  = exception.message
  end
  
  def dig_txt host, resolver
    txt_record = resolver.search(host.name, Net::DNS::TXT).answer.first
    
    if txt_record.present?
      host.extra_attr[:rbl][:data]['TXT Record'] = txt_record.value
    end
  
  rescue Exception => exception
    host.extra_attr[:rbl][:data]['Failed to get TXT record'] = exception.message
  end
  
end