class Tools::CannedReplies::CategorySerializer < ApplicationSerializer

  attributes :id, :name, :type, :category_id

  def type
    object.class.name.demodulize.underscore
  end

  def category_id
    object.respond_to?(:category_id) ? object.category_id : object.parent_id
  end

end
