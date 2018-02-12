class Tools::CannedReplies::MacrosCategoriesController < ApplicationController
  respond_to :json
  # authorize_resource

  def index
    render(
      json: resource_collection,
      each_serializer: Tools::CannedReplies::CategorySerializer,
      meta: {
        totalRecords: resource_collection.length
      }, meta_key: :pagination
    )
  end

  private

  def search_params
    params[:q]
  end

  def resource_collection
    categories + replies
  end

  def categories
    reply_category_ids = replies.pluck(:category_id).compact.uniq
    ancestor_ids = Tools::CannedReplies::MacrosCategory.where(
      id: reply_category_ids
    )
      .pluck(:ancestry)
      .compact
      .map {|i| i.split('/').map(&:to_i)}
      .flatten
      .uniq
    @categories ||= Tools::CannedReplies::MacrosCategory.find([reply_category_ids + ancestor_ids].flatten.uniq)
  end

  def replies
    @replies ||= Tools::CannedReplies::MacrosReply.ransack(search_params).result
  end

end
