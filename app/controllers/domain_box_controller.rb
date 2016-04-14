class DomainBoxController < ApplicationController
  
  def bulk_dig
  end

  def perform_bulk_dig
    @domains = DomainName.parse_multiple params[:query]
    records = params[:record_types].present? ? params[:record_types] : [:a, :mx, :ns]
    DNS::Resolver.dig_multiple @domains, type: params[:ns].to_sym, records: records
    render action: :bulk_dig
  end
  
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