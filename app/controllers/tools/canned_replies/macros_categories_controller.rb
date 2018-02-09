class Tools::CannedReplies::MacrosCategoriesController < ApplicationController
  respond_to :json
  # authorize_resource

  def index
    categories = Tools::CannedReplies::MacroCategory.all
    replies = Tools::CannedReplies::Reply.joins(:category).where("tools_canned_replies_categories.type = ?", 'Tools::CannedReplies::MacroCategory')
    collection = categories + replies
    render json: collection, each_serializer: Tools::CannedReplies::CategorySerializer, meta: {totalRecords: collection.length}, meta_key: :pagination
  end

end
