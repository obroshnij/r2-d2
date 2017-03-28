class Tools::EmailMasker

  EMAIL_REGEX = /[a-z0-9\.!#$%&'*+-\/=?_|{}~`^]+@(?:(?>[a-z0-9]+[a-z0-9\-]*[a-z0-9]+|[a-z0-9]*)\.)+[a-z]+(?:--[a-z0-9]+)?/i

  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :query, :mask

  validates :query, presence: true

  def initialize query
    @query = query.downcase.strip
    @mask  = get_mask if valid?
  end

  private

  def get_mask
    emails = query.scan(EMAIL_REGEX)

    return errors.add(:query, 'No valid emails found') if emails.blank?

    emails.map do |email|
      index = email.index '@'
      email.gsub '@', ''
      
      email.chars.map.with_index do |char, index|
        index.odd? ? '*' : char
      end.join.insert index, '@'
    end
  end

end
