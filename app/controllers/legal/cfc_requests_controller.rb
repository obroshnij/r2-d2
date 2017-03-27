class Legal::CfcRequestsController < ApplicationController
  respond_to :json

  def index
    search = Legal::CfcRequest.ransack params[:q]
    cfc_requests = search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
    render_json_collection cfc_requests
  end

  def create
    form = Legal::CfcRequest::SubmitForm.new
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

  def show
    cfc_request = Legal::CfcRequest.find params[:id]
    render_json_single cfc_request
  end

  def update
    form = Legal::CfcRequest::SubmitForm.new params[:id]
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

  def verify
    form = Legal::CfcRequest::VerifyForm.new params[:id]
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

  def mark_processed
    form = Legal::CfcRequest::ProcessForm.new params[:id]
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

end
