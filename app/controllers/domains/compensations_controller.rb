class Domains::CompensationsController < ApplicationController
  respond_to :json

  def index
    authorize! :index, Domains::Compensation
    @search = Domains::Compensation.with_data.accessible_by(current_ability).ransack params[:q]
    @compensations = @search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
    render json: @compensations, meta: pagination_dict(@compensations), meta_key: :pagination
  end

  def show
    @compensation = Domains::Compensation.find params[:id]
    authorize! :show, @compensation
    render json: @compensation
  end

  def create
    authorize! :create, Domains::Compensation
    @form = Domains::Compensation::Form.new
    if @form.submit params
      @compensation = @form.model
      render json: @compensation
    else
      respond_with @form
    end
  end

  def update
    @compensation = Domains::Compensation.find params[:id]
    authorize! :update, @compensation
    @form = Domains::Compensation::Form.new params[:id]
    if @form.submit params
      @compensation = @form.model
      render json: @compensation
    else
      respond_with @form
    end
  end

  def qa_check
    @compensation = Domains::Compensation.find params[:id]
    authorize! :qa_check, @compensation
    @form = Domains::Compensation::Form.new params[:id]
    if @form.submit params
      @compensation = @form.model
      render json: @compensation
    else
      respond_with @form
    end
  end

end
