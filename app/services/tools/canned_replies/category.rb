class Tools::CannedReplies::Category
  attr_accessor :persisted_record

  def initialize attrs
    @attrs = attrs
  end

  def origin_id
    @attrs['id']
  end

  def private?
    @attrs['type'] != "Public"
  end

  def parent_id &block
    return nil if @attrs["parent_category_id"] == 0
    block.call @attrs["parent_category_id"]
  end

  def user
    ::User.find_by_email @attrs["owner_email"]
  end

  def name
    @attrs['name']
  end

  def user_id
    user && user.id
  end

  def persisted?
    persisted_record.present?
  end

  def changed?
    persisted? && attributes_changed?
  end

  def attributes_changed?
    [
      private?  != persisted_record.private,
      name      != persisted_record.name
    ].any?
  end
end
