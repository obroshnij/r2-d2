class Legal::CfcRequest::Relation < ActiveRecord::Base
  self.table_name = 'legal_cfc_request_relations'

  belongs_to :request, class_name: 'Legal::CfcRequest', foreign_key: 'request_id'

  has_many :relations_types, class_name: 'Legal::CfcRequest::RelationsTypes', foreign_key: 'relation_id'
  has_many :relation_types, through: :relations_types
end
