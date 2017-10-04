class InternalSpammerBlacklistAssignment

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :usernames,         Array[String]
  attribute :relation_type_ids, Array[Integer]
  attribute :_destroy,          Boolean

  # validates :usernames, presence: true
  validates :usernames, format: { with: /\A[\w\d\s,]+\z/, multiline: true, message: "is (are) invalid" }, allow_blank: true

  def persisted?
    false
  end

  def relation_type_ids=(ids)
    super ids.delete_if(&:blank?)
  end

  def usernames
    super.join(', ')
  end

  def usernames_array
    @usernames
  end

  def usernames=(usernames)
    super usernames.to_s.downcase.scan(/[a-z0-9]+/)
  end

end
