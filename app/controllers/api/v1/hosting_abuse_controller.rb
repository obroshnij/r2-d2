class Api::V1::HostingAbuseController < Api::V1::BaseController

  def create
    params[:reported_by_id] = current_user.id
    params[:status] = '_new'

    form = Legal::HostingAbuse::Form.new
    if form.submit params
      render json: {}
    else
      render json: form.errors.messages, status: 422
    end
  end

end
