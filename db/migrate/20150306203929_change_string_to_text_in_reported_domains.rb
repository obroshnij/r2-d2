class ChangeStringToTextInReportedDomains < ActiveRecord::Migration
  def change
    change_column :reported_domains, :domain_name, :text, limit: nil
    change_column :reported_domains, :username, :text, limit: nil
    change_column :reported_domains, :email_address, :text, limit: nil
    change_column :reported_domains, :full_name, :text, limit: nil
    change_column :reported_domains, :epp_status, :text, limit: nil
    change_column :reported_domains, :nameservers, :text, limit: nil
    change_column :reported_domains, :ns_record, :text, limit: nil
    change_column :reported_domains, :a_record, :text, limit: nil
    change_column :reported_domains, :mx_record, :text, limit: nil
  end
end