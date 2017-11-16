class Legal::PdfiersController < ApplicationController

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def dmca
    @pdf = Legal::Pdf::Dmca.new params[:content].values.map(&:values)
    send_data @pdf.render, filename: @pdf.name, type: 'application/pdf'
  end

end
