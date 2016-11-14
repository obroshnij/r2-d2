class Legal::RblsController < ApplicationController
  respond_to :json
  authorize_resource

  def index
    @search = Legal::Rbl.ransack params[:q]
    @rbls = @search.result.order(:name).paginate(page: params[:page], per_page: params[:per_page])
  end

  def update
    @rbl = Legal::Rbl.find params[:id]
    if @rbl.update_attributes rbl_params
      render :show
    else
      respond_with @rbl
    end
  end

  def create
    @rbl = Legal::Rbl.new rbl_params
    if @rbl.save
      render :show
    else
      respond_with @rbl
    end
  end

  private

  def rbl_params
    params.require(:rbl).permit(:name, :rbl_status_id, :url, :comment)
  end

end
