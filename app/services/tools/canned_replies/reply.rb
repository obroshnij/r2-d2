class Tools::CannedReplies::Reply

  def initialize attrs
    @attrs = attrs
  end

  def _id
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

  def category_id
    @attrs["category_id"]
  end

  def user
    ::User.find_by_email @attrs["owner_email"]
  end

  def user_id
    user && user.id
  end

end
