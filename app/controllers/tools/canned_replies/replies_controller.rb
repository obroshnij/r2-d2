class Tools::CannedReplies::RepliesController < ApplicationController
  respond_to :json

  def index
    binding.pry
  end

  def show
    resource = Tools::CannedReplies::Reply.find(params[:id])
    render json: resource, serializer: Tools::CannedReplies::ReplySerializer#, meta: {totalRecords: collection.length}, meta_key: :pagination
  end

end
