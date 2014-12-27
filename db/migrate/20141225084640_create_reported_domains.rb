class CreateReportedDomains < ActiveRecord::Migration
  def change
    create_table :reported_domains do |t|
      t.belongs_to :user
      t.string     :domain_name
      t.integer    :occurrences_count
      t.string     :username
      t.string     :email_address
      t.string     :full_name
      t.boolean    :dbl
      t.boolean    :surbl
      t.boolean    :blacklisted
      t.string     :epp_status
      t.string     :nameservers
      t.string     :ns_record
      t.string     :a_record
      t.string     :mx_record
      t.boolean    :vip_domain
      t.boolean    :has_vip_domains
      t.boolean    :spammer
      t.boolean    :suspended_by_registry
      t.boolean    :suspended_by_enom
      t.boolean    :suspended_by_namecheap
      t.boolean    :suspended_for_whois
      t.boolean    :expired
      t.boolean    :inactive
      
      t.timestamps
    end
  end
end
