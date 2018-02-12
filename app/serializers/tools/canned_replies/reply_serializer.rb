class Tools::CannedReplies::ReplySerializer < ApplicationSerializer

  attributes :id, :name, :content, :category_id, :type

  def type
    object.class.name.demodulize.underscore
  end

  def content
    object.content.html_safe
  end
end
