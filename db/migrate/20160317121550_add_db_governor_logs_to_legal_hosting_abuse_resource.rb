class AddDbGovernorLogsToLegalHostingAbuseResource < ActiveRecord::Migration
  def change
    add_column :legal_hosting_abuse_resource, :db_governor_logs, :text
  end
end
