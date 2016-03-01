namespace :ldap do
  
  desc "Pull users info from AD and update accounts"
  task :setup => :environment do
    options = {
      host:       Rails.application.secrets.ldap_host,
      base:       Rails.application.secrets.search_base,
      encryption: :simple_tls,
      port:       636,
      auth: {
        username: Rails.application.secrets.ldap_uid,
        password: Rails.application.secrets.ldap_password,
        method:   :simple
      }
    }
    ldap = Net::LDAP.new options
    
    entries = ldap.search(base: "cn=users,cn=accounts,dc=namecheap,dc=directory", filter: Net::LDAP::Filter.eq('mail', '*'), return_result: true) do |entry|
    end
    
    users = entries.map do |entry|
      groups = (entry.try(:memberof) || []).map do |group|
        group.include?("cn=groups") ? group : nil
      end.compact.keep_if { |g| g[0..4] == 'cn=nc' }
      {
        uid:        entry.uid.first,
        first_name: entry.givenname.first,
        last_name:  entry.sn.first,
        email:      entry.mail.first,
        groups:     groups
      }
    end
    
    Role.destroy_all
    
    Role.create name: 'Other'
    
    Role.create({
      name: 'Billing CS',
      permission_ids: ['rbls_index'],
      groups: DirectoryGroup.where(name: ['nc-cs-billing'])
    })
    
    Role.create({
      name: 'Domain SL',
      permission_ids: [
        'domains_watched_index',
        'domains_watched_create',
        'domains_watched_destroy',
        'domains_maintenance_alerts_index',
        'domains_maintenenace_alerts_show'
      ],
      groups: DirectoryGroup.where(name: ['nc-cs-shiftleaders', 'nc-cs-domain'])
    })
    
    Role.create({
      name: 'Domain SLA',
      permission_ids: [
        'domains_watched_index',
        'domains_watched_create',
        'domains_watched_destroy',
        'domains_maintenance_alerts_index',
        'domains_maintenenace_alerts_show'
      ],
      groups: DirectoryGroup.where(name: [''])
    })
    
    Role.create({
      name: 'RM Management',
      permission_ids: [
        'legal_hosting_abuse_index',
        'legal_hosting_abuse_create',
        'legal_hosting_abuse_update',
        'legal_hosting_abuse_process',
        'legal_hosting_abuse_dismiss',
        'abuse_reports_index',
        'abuse_reports_create',
        'abuse_reports_update',
        'abuse_reports_approve',
        'rbls_index',
        'rbls_create',
        'nc_users_index',
        'nc_users_create',
        'nc_users_show',
        'nc_users_comment',
        'nc_services_index',
        'nc_services_create',
        'nc_services_show',
        'nc_services_comment',
        'la_tools_manage',
        'management_tools_monthly_reports'
      ],
      groups: DirectoryGroup.where(name: ['nc-cs-management', 'nc-rm-management'])
    })
    
    Role.create({
      name: 'Legal & Abuse CS',
      permission_ids: [
        'legal_hosting_abuse_index',
        'legal_hosting_abuse_process',
        'legal_hosting_abuse_dismiss',
        'abuse_reports_index',
        'abuse_reports_create',
        'abuse_reports_update_own',
        'rbls_index',
        'nc_users_index',
        'nc_users_show',
        'nc_users_comment',
        'nc_services_index',
        'nc_services_show',
        'nc_services_comment',
        'la_tools_manage'
      ],
      groups: DirectoryGroup.where(name: [''])
    })
    
    Role.create({
      name: 'Legal & Abuse SL',
      permission_ids: [
        'legal_hosting_abuse_index',
        'legal_hosting_abuse_process',
        'legal_hosting_abuse_dismiss',
        'abuse_reports_index',
        'abuse_reports_create',
        'abuse_reports_update_own',
        'rbls_index',
        'nc_users_index',
        'nc_users_show',
        'nc_users_comment',
        'nc_services_index',
        'nc_services_show',
        'nc_services_comment',
        'la_tools_manage'
      ],
      groups: DirectoryGroup.where(name: [''])
    })
    
    Role.create({
      name: 'NC Infrastructure',
      permission_ids: [
        
      ],
      groups: DirectoryGroup.where(name: [''])
    })
    
    Role.create({
      name: 'Tech Support',
      permission_ids: [
        
      ],
      groups: DirectoryGroup.where(name: [''])
    })
    
    Role.create({
      name: 'CS Management',
      permission_ids: [
        'management_tools_monthly_reports'
      ],
      groups: DirectoryGroup.where(name: ['nc-cs-management'])
    })
    
    Role.create({
      name: 'Domain TL',
      permission_ids: [
        'management_tools_monthly_reports'
      ],
      groups: DirectoryGroup.where(name: ['nc-cs-domain', 'nc-cs-teamleads'])
    })
    
    User.all.each do |r2_user|
      ldap_user = users.find { |u| r2_user.email.gsub('.', '') == u[:email].gsub('.', '') }
      next if ldap_user.nil?

      group_ids = ldap_user[:groups].map do |group_dn|
        name = group_dn.split(',').first.split('=').last
        DirectoryGroup.find_or_create_by(name: name).id
      end

      r2_user.group_ids = group_ids if group_ids.present?
      r2_user.uid = ldap_user[:uid]
      r2_user.name = ldap_user[:first_name] + ' ' + ldap_user[:last_name]
      r2_user.role = Role.for_user(r2_user)
      r2_user.save!
    end
  end
  
end