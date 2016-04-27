class Tools::EmailVerifier
  
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :query, :records
  
  validates :query, presence: true
  
  def initialize query
    @query = query
    perform_verification if valid?
  end
  
  private
  
  def perform_verification
    emails = query.downcase.split.map(&:strip).uniq
    verifiers = ::EmailVerifier.verify_multiple emails
    @records = verifiers.map do |email, verifier|
      {
        email:          email,
        host_name:      verifier.host,
        mailbox:        verifier.mailbox,
        status:         verifier.status,
        session:        verifier.session,
        host_error:     verifier.host_error,
        mailbox_error:  verifier.mailbox_error
      }
    end
  end
  
end