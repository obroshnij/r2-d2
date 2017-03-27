class Legal::CfcRequest < ActiveRecord::Base
  self.table_name = 'legal_cfc_requests'

  belongs_to :submitted_by, class_name: 'User', foreign_key: 'submitted_by_id'
  belongs_to :processed_by, class_name: 'User', foreign_key: 'processed_by_id'

  has_many :relations, class_name: 'Legal::CfcRequest::Relation', foreign_key: 'request_id'

  enum status:                [:_new, :_pending, :_processed]
  enum request_type:          [:check_for_fraud, :find_relations]
  enum find_relations_reason: [:legal_request, :internal_investigation]
  enum service_type:          [:domain, :hosting, :private_email]
  enum abuse_type:            [:phishing, :scam, :deliberate_spam, :other_abuse]
  enum service_status:        [:active, :suspended, :cancelled]
  enum relations_status:      [:unknown_relations, :has_relations, :has_no_relations]

  scope :with_data, -> { includes(:submitted_by, :processed_by) }

end
