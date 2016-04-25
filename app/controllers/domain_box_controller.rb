class DomainBoxController < ApplicationController
    
  def verify_email
  end
  
  def perform_email_verification
    @verifiers = EmailVerifier.verify_multiple params[:emails].downcase.split.uniq
    render action: :verify_email
  end
  
  # def unauthorized
  #   render text: request.inspect, status: 403
  # end

end