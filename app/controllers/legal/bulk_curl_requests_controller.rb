class Legal::BulkCurlRequestsController < ApplicationController
  respond_to :json

  def index
    @requests = Legal::BulkCurlRequest.by_user current_user, params[:page], params[:per_page]
  end

  def show
    @request = Legal::BulkCurlRequest.by_id params[:id]
  end

  def create
    @requests = Legal::BulkCurlRequest.enqueue params[:urls], current_user
    respond_with @requests
  end

  def destroy
    job = BackgroundJob.find params[:id]
    job.destroy
    render json: {}
  end

end
