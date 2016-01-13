class HostNameValidator < ActiveModel::EachValidator
  
  def validate_each record, attribute, value
    record.errors[attribute] << (options[:message] || "is not a valid host name") unless PublicSuffix.valid?(value)
  end

end
