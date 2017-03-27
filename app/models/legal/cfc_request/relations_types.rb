class Legal::CfcRequest::RelationsTypes < ActiveRecord::Base
  self.table_name = 'legal_cfc_requests_relations_types'

  belongs_to :relation,      class_name: 'Legal::CfcRequest::Relation', foreign_key: 'relation_id'
  belongs_to :relation_type, class_name: 'Legal::UserRelationType',     foreign_key: 'relation_type_uid'
end
