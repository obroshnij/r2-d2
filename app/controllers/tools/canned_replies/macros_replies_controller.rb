class Tools::CannedReplies::MacrosRepliesController < ApplicationController
  respond_to :json

  def show
    resource = Tools::CannedReplies::MacrosReply.find(params[:id])
    render json: resource, serializer: Tools::CannedReplies::ReplySerializer
  end

end
