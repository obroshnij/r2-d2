class Domains::CompensationsController < ApplicationController
  respond_to :json
  authorize_resource

  def index
  end

  def show
  end

  def create
    @form = Domains::Compensation::Form.new
    if @form.submit params
      @compensation = @form.model
      render :show
    else
      respond_with @form
    end
  end

end
