class CannedRepliesController < ApplicationController

  before_action :authenticate_user!

  def index
    @canned_replies = CannedReply.all
  end

  def new
    @canned_reply = CannedReply.new
  end

  def create
    @canned_reply = CannedReply.new(canned_reply_params)
    if @canned_reply.save
      flash[:notice] = "The record has been added"
      redirect_to action: :index
    else
      flash.now[:alert] = @canned_reply.errors.full_messages.join("; ")
      render action: :new
    end
  end

  def edit
    @canned_reply = CannedReply.find(params[:id])
  end

  def update
    @canned_reply = CannedReply.find(params[:id])
    if @canned_reply.update_attributes(canned_reply_params)
      flash[:notice] = "The record has been updated"
      redirect_to action: :index
    else
      flash.now[:alert] = @canned_reply.errors.full_messages.join("; ")
      render action: :edit
    end
  end

  def show
    @canned_reply = CannedReply.find(params[:id])
  end

  def destroy
    @canned_reply = CannedReply.find(params[:id])
    flash[:notice] = "The record has been deleted" if @canned_reply.destroy
    redirect_to action: :index
  end

  private

  def canned_reply_params
    params.require(:canned_reply).permit(:name, :description, :title, :body)
  end

end