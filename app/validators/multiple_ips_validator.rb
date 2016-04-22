class MultipleIpsValidator < ActiveModel::EachValidator
  
  def validate_each record, attribute, value
    valid = value.split.map(&:strip).map do |val|
      val =~ /\A\d+\.\d+\.\d+\.\d+\z/ && IPAddress.valid?(val)
    end.all? { |el| el }
    
    record.errors[attribute] << (options[:message] || 'are not valid IPv4 addresses') unless valid
  end

end
