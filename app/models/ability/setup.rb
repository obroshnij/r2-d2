class Ability::Setup
  
  RESOURCES = [
    {
      attributes:           { name: 'Legal::HostingAbuse', description: 'Legal & Abuse -> Hosting Abuse' },
      permission_groups:    [
        {
          attributes:       { name: 'Read' },
          permissions:      [
            {
              action:       'index',
              description:  'Access the list of all hosting abuse reports',
              identifier:   'legal_hosting_abuse_index'
            }
          ]
        }, {
          attributes:       { name: 'Create' },
          permissions:      [
            {
              action:       'create',
              description:  'Submit new hosting abuse reports',
              identifier:   'legal_hosting_abuse_create'
            }
          ]
        }, {
          attributes:       { name: 'Modify' },
          permissions:      [
            {
              action:       'update',
              description:  'Update existing reports submitted by any user',
              identifier:   'legal_hosting_abuse_update'
            },{
              action:       'update',
              description:  'Update existing reports submitted by the current user',
              conditions:   '{ reported_by_id: current_user.id }',
              identifier:   'legal_hosting_abuse_update_own'
            },{
              action:       'process',
              description:  'Mark existing hosting abuse reports as processed',
              identifier:   'legal_hosting_abuse_process'
            },{
              action:       'dismiss',
              description:  'Mark existing hosting abuse reports as dismissed',
              identifier:   'legal_hosting_abuse_dismiss'
            },{
              action:       'unprocess',
              description:  'Mark existing hosting abuse reports as unprocessed',
              identifier:   'legal_hosting_abuse_unprocess'
            }
          ]
        }
      ]
    }, {
      attributes:           { name: 'AbuseReport', description: 'Legal & Abuse -> Abuse Reports' },
      permission_groups:    [
        {
          attributes:       { name: 'Read' },
          permissions:      [
            {
              action:       'index',
              description:  'Access the list of all abuse reports',
              identifier:   'abuse_reports_index'  
            }
          ]
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
      resource = Ability::Resource.create hash[:attributes]
      
      hash[:permission_groups].each do |hash|
        group = Ability::PermissionGroup.create hash[:attributes].merge({ resource_id: resource.id })
        
        hash[:permissions].each do |hash|
          Ability::Permission.create hash.merge({ group_id: group.id })
        end
      end
    end
  end
  
  def self.cleanup!
    Ability::Resource.destroy_all
    Ability::PermissionGroup.destroy_all
    Ability::Permission.destroy_all
  end
  
end