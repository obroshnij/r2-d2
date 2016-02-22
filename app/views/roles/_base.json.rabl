attributes :id, :name, :group_ids

node(:groups)    { |r| DirectoryGroup.where(id: r.group_ids).map(&:name) }