class Legal::CfcRequest::RelationForm

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations

  attribute :request_id,        Integer
  attribute :username,          Array[String]
  attribute :relation_type_ids, Array[String]
  attribute :certainty,         Integer
  attribute :comment,           String
  attribute :_destroy,          Boolean
  attribute :id,                Integer

  validates :username,          presence: true
  validates :certainty,         presence: true, if: :certainty_required?
  validates :certainty,         numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }, if: :certainty_required?
  validates :relation_type_ids, presence: true
  validates :comment,           presence: true, if: :other_relation_type?

  attr_reader :cid, :parent

  def initialize cid, attrs, parent
    super attrs
    @cid = cid
    @parent = parent
  end

  def username= str = ""
    super str.downcase.split(/[^a-zA-Z0-9]+/)
  end

  def relation_type_ids= arr
    super arr.select(&:present?)
  end

  def other_relation_type?
    relation_type_ids.include? 'other'
  end

  def certainty_required?
    parent.model.request_type == 'find_relations'
  end

  def persist!
    return create  if id.blank?   && _destroy.blank?
    return update  if id.present? && _destroy.blank?
    return destroy if id.present? && _destroy.present?
  end

  private

  def create
    username.each do |name|
      Legal::CfcRequest::Relation.create relation_attrs(name)
    end
  end

  def update
    relation = Legal::CfcRequest::Relation.find id
    if username.length == 1 && username.first == relation.username
      relation.update_attributes relation_attrs(username.first)
    else
      relation.destroy
      create
    end
  end

  def destroy
    relation = Legal::CfcRequest::Relation.find id
    relation.destroy
  end

  def relation_attrs username
    self.attributes.slice(
      :request_id,
      :certainty,
      :comment,
      :relation_type_ids
    ).merge({
      username: username
    })
  end

end
