class CreateLegalHostingAbuse < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse do |t|
      t.integer  :reported_by_id
      t.integer  :status,            default: 0
      t.integer  :service_id
      t.integer  :type_id
      t.integer  :server_id
      t.integer  :efwd_server_id
      t.integer  :ticket_id
      t.integer  :nc_user_id
      t.integer  :uber_service_id
      t.string   :username,          index: true
      t.string   :resold_username
      t.integer  :management_type_id
      t.integer  :reseller_plan_id
      t.integer  :shared_plan_id
      t.integer  :vps_plan_id
      t.string   :server_rack_label
      t.string   :subscription_name, index: true
      t.integer  :suggestion_id
      t.text     :suspension_reason
      t.string   :scan_report_path
      t.text     :tech_comments
      
      t.timestamps null: false
    end
  end
end
