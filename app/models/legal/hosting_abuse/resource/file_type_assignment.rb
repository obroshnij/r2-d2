class Legal::HostingAbuse::Resource::FileTypeAssignment < ActiveRecord::Base
  self.table_name = 'legal_hosting_abuse_resource_file_type_assignments'

  belongs_to :resource,  class_name: 'Legal::HostingAbuse::Resource',           foreign_key: 'resource_id'
  belongs_to :file_type, class_name: 'Legal::HostingAbuse::Resource::FileType', foreign_key: 'file_type_id'
end
