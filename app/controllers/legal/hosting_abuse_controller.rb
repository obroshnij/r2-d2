class Legal::HostingAbuseController < ApplicationController
  respond_to :json
  before_action :find_hosting_abuse, only: [:update, :mark_processed, :mark_dismissed, :show_attach]
  
  def index
    authorize! :index, Legal::HostingAbuse
    @search = Legal::HostingAbuse.ransack params[:q]
    @hosting_abuse = @search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
  end
  
  def show
    @hosting_abuse = Legal::HostingAbuse.find params[:id]
    authorize! :show, @hosting_abuse
  end
  
  def create
    authorize! :create, Legal::HostingAbuse
    @form = Legal::HostingAbuse::Form.new
    if @form.submit params
      @hosting_abuse = @form.model
      render :show
    else
      respond_with @form
    end
  end
  
  def update
    authorize! :update, @hosting_abuse
    update_model
  end
  
  def mark_dismissed
    authorize! :mark_dismissed, @hosting_abuse
    update_model
  end
  
  def mark_processed
    authorize! :mark_processed, @hosting_abuse
    @form = Legal::HostingAbuse::Form::MarkProcessed.new params[:id]
    if @form.submit params
      @hosting_abuse = @form.model
      render :show
    else
      respond_with @form
    end
  end
  
  def show_attach
    authorize! :mark_processed, @hosting_abuse
    respond_to do |format|
      format.text { send_data @hosting_abuse.canned_attach.render(:txt), filename: "#{@hosting_abuse.canned_attach.name}.txt", type: 'text/plain' }
      format.pdf  { send_data @hosting_abuse.canned_attach.render(:pdf), filename: "#{@hosting_abuse.canned_attach.name}.pdf", type: 'application/pdf' }
    end
  end
  
  private
  
  def find_hosting_abuse
    @hosting_abuse = Legal::HostingAbuse.find params[:id]
  end
  
  def update_model
    @form = Legal::HostingAbuse::Form.new params[:id]
    if @form.submit params
      @hosting_abuse = @form.model
      render :show
    else
      respond_with @form
    end
  end
  
end