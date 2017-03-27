class Legal::UserRelationType < ActiveRecord::Base
  self.table_name  = 'legal_user_relation_types'
  self.primary_key = 'uid'
end
