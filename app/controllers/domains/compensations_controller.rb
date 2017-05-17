class Domains::CompensationsController < ApplicationController
  respond_to :json
  before_action :format_search_params, only: [:index, :export]

  def index
    authorize! :index, Domains::Compensation
    @search = Domains::Compensation.with_data.accessible_by(current_ability).ransack params[:q]
    @compensations = @search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
    render_json_collection @compensations
  end

  def export
    authorize! :export, Domains::Compensation
    @search = Domains::Compensation.with_data.accessible_by(current_ability).ransack params[:q]
    @compensations = @search.result(distinct: true).order(created_at: :desc)
    request.format = 'xlsx'
    respond_to do |format|
      format.xlsx { render xlsx: 'export', filename: 'Export' }
    end
  end

  def show
    @compensation = Domains::Compensation.find params[:id]
    authorize! :show, @compensation
    render_json_single @compensation
  end

  def create
    authorize! :create, Domains::Compensation
    @form = Domains::Compensation::Form.new nil, current_user, 'created'
    if @form.submit params
      @compensation = @form.model
      render_json_single @compensation
    else
      respond_with @form
    end
  end

  def update
    @compensation = Domains::Compensation.find params[:id]
    authorize! :update, @compensation
    @form = Domains::Compensation::Form.new params[:id], current_user, 'updated'
    if @form.submit params
      @compensation = @form.model
      render_json_single @compensation
    else
      respond_with @form
    end
  end

  def qa_check
    @compensation = Domains::Compensation.find params[:id]
    authorize! :qa_check, @compensation
    @form = Domains::Compensation::Form.new params[:id], current_user, 'checked'
    if @form.submit params
      @compensation = @form.model
      render_json_single @compensation
    else
      respond_with @form
    end
  end

  private

  def format_search_params
    if params[:q] && params[:q][:client_satisfied_eq] == 'nil'
      params[:q].except!(:client_satisfied_eq)
      params[:q][:client_satisfied_null] = '1'
    end
  end

end
