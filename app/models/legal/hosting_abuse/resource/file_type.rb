class Legal::HostingAbuse::Resource::FileType < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_file_types'

  has_many :assignments, class_name: 'Legal::HostingAbuse::Resource::FileTypeAssignment', foreign_key: 'file_type_id'
  has_many :resource,    through: :assignments
end
