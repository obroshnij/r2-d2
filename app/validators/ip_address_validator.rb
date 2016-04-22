class IpAddressValidator < ActiveModel::EachValidator
  
  def validate_each record, attribute, value
    unless value =~ /\d+\.\d+\.\d+\.\d+/ && IPAddress.valid?(value)
      record.errors[attribute] << (options[:message] || 'is not a valid IPv4 address')
    end
  end

end
