class Tools::CannedReplies::CannedCategoriesController < ApplicationController
  respond_to :json
  # authorize_resource

  def index
    categories = Tools::CannedReplies::CannedCategory.all
    replies = Tools::CannedReplies::Reply.joins(:category).where("tools_canned_replies_categories.type = ?", 'Tools::CannedReplies::CannedCategory')
    collection = categories + replies
    render json: collection, each_serializer: Tools::CannedReplies::CategorySerializer, meta: {totalRecords: collection.length}, meta_key: :pagination
  end

end
