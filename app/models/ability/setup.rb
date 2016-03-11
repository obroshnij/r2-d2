class Ability::Setup
  
  RESOURCES = [
    {
      subjects:         ['Domains::WatchedDomain'],
      description:      'Domains -> Watched Domains',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access domains list',
          identifier:   'domains_watched_index'
        }, {
          actions:      ['create'],
          description:  'Add new domains',
          identifier:   'domains_watched_create'
        }, {
          actions:      ['destroy'],
          description:  'Delete domains',
          identifier:   'domains_watched_destroy'
        }
      ]
    }, {
      subjects:         ['maintenance_alert'],
      description:      'Domains -> Maintenance Alerts',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access alerts list',
          identifier:   'domains_maintenance_alerts_index'
        }, {
          actions:      ['show'],
          description:  'Generate predefined status posts',
          identifier:   'domains_maintenenace_alerts_show'
        }
      ]
    }, {
      subjects:         ['Legal::HostingAbuse'],
      description:      'Legal & Abuse -> Hosting Abuse',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access reports list',
          identifier:   'legal_hosting_abuse_index'
        }, {
          actions:      ['create'],
          description:  'Submit new reports',
          identifier:   'legal_hosting_abuse_create'
        }, {
          actions:      ['show', 'update'],
          description:  'Edit reports submitted by any user',
          identifier:   'legal_hosting_abuse_update'
        }, {
          actions:      ['show', 'update'],
          conditions:   '{ reported_by_id: user.id, status: ["_new", "_edited"] }',
          description:  "Edit reports submitted by current user if it's new or edited",
          identifier:   'legal_hosting_abuse_update_own'
        }, {
          actions:      ['show', 'update'],
          conditions:   '{ status: "_dismissed" }',
          description:  "Edit reports submitted by any user if it's dismissed",
          identifier:   'legal_hosting_abuse_update_dismissed'
        }, {
          actions:      ['mark_processed'],
          description:  'Mark reports as processed',
          identifier:   'legal_hosting_abuse_process'
        }, {
          actions:      ['mark_dismissed'],
          description:  'Mark reports as dismissed',
          identifier:   'legal_hosting_abuse_dismiss'
        }
      ]
    }, {
      subjects:         ['AbuseReport'],
      description:      'Legal & Abuse -> Abuse Reports',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access reports list',
          identifier:   'abuse_reports_index'  
        }, {
          actions:      ['create', 'update_abuse_report_form'],
          description:  'Submit new reports',
          identifier:   'abuse_reports_create'
        }, {
          actions:      ['edit', 'update'],
          description:  'Edit reports submitted by any user',
          identifier:   'abuse_reports_update'
        }, {
          actions:      ['edit', 'update'],
          conditions:   '{ reported_by: user.id }',
          description:  'Edit reports submitted by current user',
          identifier:   'abuse_reports_update_own'
        }, {
          actions:      ['approve'],
          description:  'Mark reports as approved',
          identifier:   'abuse_reports_approve'
        }
      ]
    }, {
      subjects:         ['Rbl'],
      description:      'Legal & Abuse -> Multi RBL',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access the list',
          identifier:   'rbls_index'
        }, {
          actions:      ['create'],
          description:  'Add new entries',
          identifier:   'rbls_create'
        }
      ]
    }, {
      subjects:         ['NcUser'],
      description:      'Legal & Abuse -> Namecheap Users',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access users list',
          identifier:   'nc_users_index'
        }, {
          actions:      ['create'],
          description:  'Add new users',
          identifier:   'nc_users_create'
        }, {
          actions:      ['show'],
          description:  'See detailed info about the user',
          identifier:   'nc_users_show'
        }, {
          actions:      ['update'],
          description:  'Leave comments',
          identifier:   'nc_users_comment'
        }
      ]
    }, {
      subjects:         ['NcService'],
      description:      'Legal & Abuse -> Namecheap Domains / Private Emails',
      
      permissions:      [
        {
          actions:      ['index'],
          description:  'Access the services list',
          identifier:   'nc_services_index'
        }, {
          actions:      ['create'],
          description:  'Add new entries',
          identifier:   'nc_services_create'
        }, {
          actions:      ['show'],
          description:  'See detailed info about the service',
          identifier:   'nc_services_show'
        }, {
          actions:      ['update'],
          description:  'Leave comments',
          identifier:   'nc_services_comment'
        }
      ]
    }, {
      subjects:         ['la_tool'],
      description:      'Legal & Abuse -> Tools (Everything else)',
      
      permissions:      [
        {
          actions:     ['manage'],
          description: 'Access L&A tools',
          identifier:  'la_tools_manage'
        }
      ]
    }, {
      subjects:         ['manager_tool'],
      description:      'Management Tools',
      
      permissions:      [
        {
          actions:     ['monthly_reports', 'generate_monthly_reports'],
          description: 'Monthly reports',
          identifier:  'management_tools_monthly_reports'
        }, {
          actions:     ['welcome_emails', 'generate_welcome_emails'],
          description: 'Welcome Emails',
          identifier:  'management_tools_welcome_emails'
        }
      ]
    }, {
      subjects:         ['User', 'Role'],
      description:      'User Management',
      
      permissions:      [
        {
          actions:      ['manage'],
          description:  'Manage users, roles and permissions',
          identifier:   'users_roles_manage'
        }
      ]
    }
  ]
  
  def self.seed!
    cleanup!
    create_resources!
  end
  
  private
  
  def self.create_resources!
    RESOURCES.each do |hash|
      resource = Ability::Resource.create subjects: hash[:subjects], description: hash[:description]
      
      hash[:permissions].each do |hash|
        Ability::Permission.create hash.merge({ resource_id: resource.id })
      end
    end
  end
  
  def self.cleanup!
    Ability::Resource.destroy_all
    Ability::Permission.destroy_all
  end
  
end