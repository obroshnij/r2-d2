class Tools::CannedReplies::CategoriesController < ApplicationController
  respond_to :json
  # authorize_resource

  def index
    collection = Tools::CannedReplies::Reply.all + Tools::CannedReplies::Category.all
    render json: collection, each_serializer: Tools::CannedReplies::CategorySerializer, meta: {totalRecords: collection.length}, meta_key: :pagination
  end

end
