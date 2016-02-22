class Ability::Setup
  
  RESOURCES = [
    {
      attributes:         { name: 'Legal::HostingAbuse', description: 'Legal & Abuse -> Hosting Abuse' },
      permission_groups:  [
        {
          attributes:     { name: 'Read' },
          permissions:    [
            { action: 'index',     description: 'Access the list of all hosting abuse reports' }
          ]
        }, {
          attributes:     { name: 'Create' },
          permissions:    [
            { action: 'create',    description: 'Submit new hosting abuse reports' }
          ]
        }, {
          attributes:     { name: 'Modify', exclusive: true },
          permissions:    [
            { action: 'update',    description: 'Update existing reports submitted by any user' },
            { action: 'update',    description: 'Update existing reports submitted by the current user', conditions: "{ reported_by_id: current_user.id }" }
          ]
        }, {
          attributes:     { name: 'Modify' },
          permissions:    [
            { action: 'process',   description: 'Mark existing hosting abuse reports as processed' },
            { action: 'dismiss',   description: 'Mark existing hosting abuse reports as dismissed' },
            { action: 'unprocess', description: 'Mark existing hosting abuse reports as unprocessed' }
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