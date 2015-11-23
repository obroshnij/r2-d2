require 'thread/pool'

module EmailVerifier
  
  def self.verify email
    Verifier.new(email).verify
  end
  
  def self.verify_multiple emails
    result = {}
    pool = Thread.pool 50
    emails.each do |email|
      pool.process(email) do |email|
        result[email] = Verifier.new email
        result[email].verify
      end
    end
    pool.shutdown
    result
  end
  
end