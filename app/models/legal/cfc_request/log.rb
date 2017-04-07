class Legal::CfcRequest::Log < ActiveRecord::Base
  self.table_name = 'legal_cfc_request_logs'

  belongs_to :request, class_name: 'Legal::CfcRequest', foreign_key: 'request_id'
  belongs_to :user

  default_scope { order(created_at: :desc) }
end
