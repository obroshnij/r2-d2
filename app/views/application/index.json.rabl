object false

node :environment do
  Rails.env
end

node :current_user do
  current_user.as_json(only: [:id, :name, :email])
end

node :current_ability do
  current_ability.as_json
end

node :entities do
  {
    legal: {
      hosting_abuse: {
        ddos: {
          block_type: Legal::HostingAbuse::Ddos::BlockType.all.as_json(only: [:id, :name])
        },
        resource: {
          abuse_type:    Legal::HostingAbuse::Resource::AbuseType.all.as_json(only: [:id, :name]),
          impact:        Legal::HostingAbuse::Resource::Impact.all.as_json(only: [:id, :name]),
          type:          Legal::HostingAbuse::Resource::ResourceType.all.as_json(only: [:id, :name]),
          upgrade:       Legal::HostingAbuse::Resource::Upgrade.all.as_json(only: [:id, :name])
        },
        spam: {
          detection_method: Legal::HostingAbuse::Spam::DetectionMethod.all.as_json(only: [:id, :name]),
          queue_type:       Legal::HostingAbuse::Spam::QueueType.all.as_json(only: [:id, :name]),
          content_type:     Legal::HostingAbuse::Spam::ContentType.all.as_json(only: [:id, :name]),
          reporting_party:  Legal::HostingAbuse::Spam::ReportingParty.all.as_json(only: [:id, :name])
        },
        service:         Legal::HostingAbuse::Service.all.as_json(only: [:id, :name]),
        type:            Legal::HostingAbuse::AbuseType.all.as_json(only: [:id, :name]),
        management_type: Legal::HostingAbuse::ManagementType.all.as_json(only: [:id, :name]),
        reseller_plan:   Legal::HostingAbuse::ResellerPlan.all.as_json(only: [:id, :name]),
        shared_plan:     Legal::HostingAbuse::SharedPlan.all.as_json(only: [:id, :name]),
        suggestion:      Legal::HostingAbuse::Suggestion.all.as_json(only: [:id, :name])
      }
    },
    navs: Nav.accessible_by_as_json(current_ability)
  }
end