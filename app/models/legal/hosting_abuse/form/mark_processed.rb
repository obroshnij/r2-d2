class Legal::HostingAbuse::Form::MarkProcessed
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :status,                  String
  attribute :ticket_id,               Integer
  attribute :ticket_identifier,       String
  attribute :uber_service_id,         Integer
  attribute :uber_service_identifier, String
  attribute :nc_user_id,              Integer
  attribute :nc_username,             String
  attribute :updated_by_id,           Integer
  attribute :comment,                 String
  attribute :log_action,              String
  attribute :decision_id,             Integer
  attribute :disregard_reason,        String
  
  attribute :nc_user_signup,          String
  attribute :nc_user_signup_date,     Date
  attribute :pe_suspended,            Boolean
  
  attribute :ip_is_blacklisted,       Boolean
  attribute :blacklisted_ip,          String
  attribute :reported_ip,             String
  attribute :reported_ip_blacklisted, Boolean
  
  validates :ticket_identifier,       presence: true, format: { with: /\A[a-z]+(?>\-[0-9]+)+\z/i }
  validates :comment,                 presence: true, if: -> { @hosting_abuse._processed? }
  validates :uber_service_identifier, format: { with: /\A[0-9]+\z/ }, allow_blank: true
  validates :disregard_reason,        presence: true, if: :disregard_reason_required?
  
  validates :blacklisted_ip,          presence: true, multiple_ips: true, if: :blacklisted_ip_required?
  validates :reported_ip,             presence: true, multiple_ips: true, allow_nil: true
  
  with_options if: :private_email? do |f|
    f.validates :nc_username,         presence: true
    f.validates :nc_user_signup,      presence: true
    f.validate  :sign_up_date_must_be_valid
  end
  
  def disregard_reason_required?
    decision_id != @hosting_abuse.decision_id
  end
  
  def sign_up_date_must_be_valid
    Date.parse(nc_user_signup) rescue errors.add(:nc_user_signup, 'is invalid')
  end
  
  def initialize hosting_abuse_id
    @hosting_abuse = Legal::HostingAbuse.find hosting_abuse_id
  end
  
  def private_email?
    @hosting_abuse.service_id == 5
  end
  
  def blacklisted_ip_required?
    return true if @hosting_abuse.type_id == 1 && [3, 4].include?(@hosting_abuse.service_id)
    ip_is_blacklisted == true
  end
  
  def model
    @hosting_abuse
  end
  
  def ticket_identifier= identifier
    if identifier.present?
      identifier = identifier.strip.upcase
      @ticket_id = Legal::KayakoTicket.find_or_create_by(identifier: identifier).id
      super identifier
    end
  end
  
  def uber_service_identifier= identifier
    if identifier.present?
      identifier = identifier.strip
      @uber_service_id = Legal::UberService.find_or_create_by(identifier: identifier).id
      super identifier
    end
  end
  
  def nc_username= username
    if username.present?
      username = username.strip.downcase
      @nc_user_id = NcUser.create_with(signed_up_on: nc_user_signup_date).find_or_create_by(username: username).id
      super username
    end
  end
  
  def nc_user_signup= date
    @nc_user_signup_date = Date.parse(date) rescue nil
    super date
  end
  
  def status= status
    @log_action = @hosting_abuse._processed? ? 'case info edited' : 'processed'
    super status
  end
    
  def submit params
    self.attributes = params
    return false unless valid?
    persist!
    persist_pe_incident! if private_email?
    true
  end
  
  private
  
  def persist!
    @hosting_abuse.assign_attributes hosting_abuse_params
    persist_email_abuse
    @hosting_abuse.save!
  end
  
  def persist_email_abuse
    if !ip_is_blacklisted.nil? && !blacklisted_ip.nil? && (@hosting_abuse.spam || @hosting_abuse.pe_spam)
      (@hosting_abuse.spam || @hosting_abuse.pe_spam).assign_attributes ip_is_blacklisted: ip_is_blacklisted, blacklisted_ip: blacklisted_ip
    end
    
    if !reported_ip.nil? && !reported_ip_blacklisted.nil? && (@hosting_abuse.spam || @hosting_abuse.pe_spam)
      (@hosting_abuse.spam || @hosting_abuse.pe_spam).assign_attributes reported_ip: reported_ip, reported_ip_blacklisted: reported_ip_blacklisted
    end
  end
  
  def hosting_abuse_params
    attr_names = Legal::HostingAbuse.attribute_names.map(&:to_sym) + [:updated_by_id, :comment, :log_action]
    self.attributes.slice(*attr_names).delete_if { |key, val| val.nil? }
  end
  
  def persist_pe_incident!
    pe_info = PrivateEmailInfo.where(hosting_abuse_id: @hosting_abuse.id).first
    abuse_report_id = pe_info.present? ? pe_info.abuse_report.id : nil
    
    form = PeAbuseForm.new abuse_report_id
    attrs = {
      reported_by:         updated_by_id,
      processed_by:        updated_by_id,
      processed:           true,
      comment:             comment,
      suspended:           pe_suspended,
      reported_by_string:  @hosting_abuse.reported_by.name,
      warning_ticket_id:   Legal::KayakoTicket.find(ticket_id).identifier,
      name:                @hosting_abuse.subscription_name,
      username:            nc_username,
      signed_up_on_string: nc_user_signup_date.strftime('%m/%d/%Y')
    }
    form.submit pe_abuse_form: attrs
    form.model.private_email_info.update_attributes hosting_abuse_id: @hosting_abuse.id
  end
end