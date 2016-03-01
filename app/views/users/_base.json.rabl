attributes :id, :name, :email, :auto_role, :role_id

node(:role, if: -> (u) { u.role_id })               { |u| u.auto_role ? "#{u.role.name} (auto)" : u.role.name }
node(:latest_sign_in)                               { |u| u.current_sign_in_at.present? ? u.current_sign_in_at.strftime('%d %b %Y, %H:%M') : 'Never signed in' }
node(:groups, if: -> (u) { u.group_ids.present? })  { |u| u.groups.map(&:name) }