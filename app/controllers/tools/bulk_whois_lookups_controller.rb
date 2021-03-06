class Tools::BulkWhoisLookupsController < ApplicationController
  respond_to :json
  
  def index
    @lookups = Tools::BulkWhoisLookup.by_user current_user, params[:page], params[:per_page]
  end
  
  def show
    @lookup = Tools::BulkWhoisLookup.by_id params[:id]
  end
  
  def create
    @lookup = Tools::BulkWhoisLookup.enqueue params[:query], params[:keep_retrying], current_user
    respond_with @lookup
  end
  
  def retry
    @lookup = Tools::BulkWhoisLookup.by_id params[:id]
    @lookup.retry
    render :show
  end
  
  def destroy
    job = BackgroundJob.find params[:id]
    job.destroy
    render json: {}
  end
  
end