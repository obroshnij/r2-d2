attributes :id, :name, :permission_ids, :users_names, :group_ids

node(:groups)    { |r| DirectoryGroup.where(id: r.group_ids).map(&:name) }