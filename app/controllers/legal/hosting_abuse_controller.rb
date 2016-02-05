class Legal::HostingAbuseController < ApplicationController
  respond_to :json
  before_action :authenticate_user!
  authorize_resource
  
  def index
    @search = Legal::HostingAbuse.ransack params[:q]
    @hosting_abuse = @search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
  end
  
  def show
    @hosting_abuse = Legal::HostingAbuse.find params[:id]
  end
  
  def create
    @form = Legal::HostingAbuse::Form.new
    if @form.submit params
      @hosting_abuse = @form.model
      render :show
    else
      respond_with @form
    end
  end
  
  def update
    @form = Legal::HostingAbuse::Form.new params[:id]
    if @form.submit params
      @hosting_abuse = @form.model
      render :show
    else
      respond_with @form
    end
  end
  
end