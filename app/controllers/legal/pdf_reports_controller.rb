class Legal::PdfReportsController < ApplicationController
  respond_to :json
  authorize_resource
  wrap_parameters :pdf_report, include: Legal::PdfReport.attribute_names + %w{ order }

  def import
    @handler = Legal::PdfReport::Handler.new current_user.id
    if @handler.import params
      render json: {}
    else
      respond_with @handler
    end
  end

  def index
    @search = Legal::PdfReport.ransack params[:q]
    @reports = @search.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @report = Legal::PdfReport.find params[:id]
  end

  def create
    @report = Legal::PdfReport.new report_params
    if @report.save
      render :show
    else
      respond_with @report
    end
  end

  def toggle_edit
    @report = Legal::PdfReport.find params[:id]

    if @report.edited_by_id
      @report.update_attributes edited_by_id: nil
    else
      Legal::PdfReport.where(edited_by_id: current_user.id).update_all(edited_by_id: nil)
      @report.update_attributes edited_by_id: current_user.id
    end

    render :show
  end

  def update
    @report = Legal::PdfReport.find params[:id]
    ap report_params
    if @report.update_attributes report_params
      render :show
    else
      respond_with @report
    end
  end

  def download
    @report = Legal::PdfReport.find params[:id]
    send_data @report.render_pdf(params[:ids]), filename: @report.pdf_name, type: 'application/pdf'
  end

  def merge
    @report = Legal::PdfReport.find params[:id]
    if @report.merge params[:to_merge]
      render :show
    else
      respond_with @report
    end
  end

  private

  def report_params
    params.require(:pdf_report).permit(:username, :created_by_id, :edited_by_id, :order => [])
  end

end
