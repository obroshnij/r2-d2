class NotNilValidator < ActiveModel::EachValidator

  def validate_each record, attribute, value
    if value.nil?
      record.errors[attribute] << (options[:message] || "can't be blank")
    end
  end

end
