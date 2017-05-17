class Legal::CfcRequestsController < ApplicationController
  respond_to :json

  def index
    authorize! :index, Legal::CfcRequest
    search = Legal::CfcRequest.with_data.ransack params[:q]
    cfc_requests = search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
    render_json_collection cfc_requests
  end

  def check_errors
    form = Legal::CfcRequest::SubmitForm.new nil, current_ability
    form.submit params, false
    render json: { errors: form.errors.messages, recheck_reason_required: form.recheck_reason_required? }
  end

  def create
    authorize! :create, Legal::CfcRequest
    form = Legal::CfcRequest::SubmitForm.new nil, current_ability
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

  def show
    cfc_request = Legal::CfcRequest.find params[:id]
    authorize! :show, Legal::CfcRequest
    render_json_single cfc_request
  end

  def update
    authorize! :update, Legal::CfcRequest
    form = Legal::CfcRequest::SubmitForm.new params[:id], current_ability
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

  def verify
    authorize! :process, Legal::CfcRequest
    form = Legal::CfcRequest::VerifyForm.new params[:id]
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

  def mark_processed
    authorize! :process, Legal::CfcRequest
    form = Legal::CfcRequest::ProcessForm.new params[:id]
    form.submit(params) ? render_json_single(form.model) : respond_with(form)
  end

end
