class Tools::CannedReplies::CannedRepliesController < ApplicationController
  respond_to :json

  def show
    resource = Tools::CannedReplies::CannedReply.find(params[:id])
    render json: resource, serializer: Tools::CannedReplies::ReplySerializer
  end

end
