class Tools::CannedReplies::Category
  def initialize attrs
    @attrs = attrs
  end

  def _id
    @attrs['id']
  end

  def private?
    @attrs['type'] != "Public"
  end

  def parent_id
    @attrs["parent_category_id"] == 0 ? nil : @attrs["parent_category_id"]
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

end
