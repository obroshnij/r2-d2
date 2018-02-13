class Tools::CannedReplies::Reply
  attr_accessor :persisted_record

  def initialize attrs
    @attrs = attrs
  end

  def origin_id
    @attrs['id']
  end

  def name
    @attrs['title']
  end

  def content
    @attrs['content']
  end

  def private?
    @attrs['type'] != "Public"
  end

  def category_id &block
    return nil if @attrs["category_id"] == 0
    block.call @attrs["category_id"]
  end

  def user
    ::User.find_by_email @attrs["owner_email"]
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
      name      != persisted_record.name,
      content   != persisted_record.content
    ].any?
  end

end
