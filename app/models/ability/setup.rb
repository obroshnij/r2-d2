class Ability::Setup

  RESOURCES = [
    {
      subjects:         ['Tools::InternalDomain'],
      description:      'Tools -> Internal Domains',

      permissions:      [
        {
          actions:      ['index'],
          description:  'Access domains list',
          identifier:   'tools_internal_domains_index'
        }, {
          actions:      ['create'],
          description:  'Add new domains',
          identifier:   'tools_internal_domains_create'
        }, {
          actions:      ['update'],
          description:  'Edit existing domains',
          identifier:   'tools_internal_domains_update'
        }, {
          actions:      ['destroy'],
          description:  'Delete domains',
          identifier:   'tools_internal_domains_destroy'
        }
      ]
    }, {
      subjects:         ['Domains::Compensation'],
      description:      'Domains & General -> Compensation System',

      permissions:      [
        {
          actions:      ['index'],
          description:  'Access the list of all form submissions',
          identifier:   'domains_compensation_index'
        }, {
          actions:      ['index'],
          conditions:   '{ submitted_by_id: user.id }',
          description:  'Access the list of form submissions created by current user',
          identifier:   'domains_compensation_index_own'
        }, {
          actions:      ['create'],
          description:  'Submit the compensation tracking form',
          identifier:   'domains_compensation_create'
        }, {
          actions:      ['show', 'update'],
          conditions:   '{ submitted_by_id: user.id }',
          description:  'Update form submissions created by current user',
          identifier:   'domains_compensation_update'
        }, {
          actions:      ['show', 'update'],
          description:  'Update form submissions created by any user',
          identifier:   'domains_compensation_update_all'
        }, {
          actions:      ['qa_check'],
          description:  'Check form submissions on behalf of QA',
          identifier:   'domains_compensation_qa_check'
        }
      ]
    }, {
      subjects:         ['Domains::Compensation::Statistic'],
      description:      'Domains & General -> Compensation Stats',

      permissions: [
        {
          actions:      ['index', 'show'],
          description:  'Access compensation system statistics',
          identifier:   'domains_compensation_stats_show'
        }
      ]
    }, {
      subjects:         ['Domains::WatchedDomain'],
      description:      'Domains & General -> Watched Domains',

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
      description:      'Domains & General -> Maintenance Alerts',

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
      subjects:         ['Legal::CfcRequest'],
      description:      'Legal & Abuse -> CFC Requests',

      permissions:      [
        {
          actions:      ['index'],
          description:  'Access requests list',
          identifier:   'legal_cfc_requests_index'
        }, {
          actions:      ['create'],
          description:  'Submit new requests',
          identifier:   'legal_cfc_requests_create'
        }, {
          actions:      ['show', 'update'],
          description:  'Edit existing requests',
          identifier:   'legal_cfc_requests_edit'
        }, {
          actions:      ['show', 'process'],
          description:  'Mark requests as processed',
          identifier:   'legal_cfc_requests_process'
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
      subjects:         ['Legal::Rbl'],
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
        }, {
          actions:      ['update'],
          description:  'Edit existing entries',
          identifier:   'rbls_update'
        }
      ]
    }, {
      subjects: ['Legal::NcUser'],
      description: 'Legal & Abuse -> Namecheap Users',

      permissions: [
        {
          actions: ['index'],
          description: 'Access users list',
          identifier: 'legal_nc_users_index'
        }, {
          actions: ['create'],
          description: 'Add new users',
          identifier: 'legal_nc_users_create'
        }, {
          actions: ['show'],
          description: 'See detailed info about the user',
          identifier: 'legal_nc_users_show'
        }, {
          actions: ['update'],
          description: 'Leave comments',
          identifier: 'legal_nc_users_comment'
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
      subjects:         ['Legal::PdfReport'],
      description:      'Legal & Abuse -> PDFier',

      permissions: [
        {
          actions:     ['manage'],
          description: 'Access PDFier tool',
          identifier:  'legal_pdfier_manage'
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
