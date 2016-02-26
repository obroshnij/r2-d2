class CreateLegalHostingAbusePeSpam < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_pe_spam do |t|
      t.integer :report_id
      t.integer :detection_method_id
      t.integer :pe_content_type_id
      t.text    :other_detection_method
      t.integer :sent_emails_amount
      t.integer :recepients_per_email
      t.date    :sent_emails_start_date
      t.date    :sent_emails_end_date
      t.text    :example_complaint
      t.boolean :ip_is_blacklisted
      t.string  :blacklisted_ip
      t.string  :reported_ip
      t.boolean :reported_ip_blacklisted
      t.integer :postfix_deferred_queue
      t.integer :postfix_active_queue
      t.integer :mailer_daemon_queue
      t.text    :header
      t.text    :body
      t.text    :bounce
      t.boolean :outbound_blocked
      
      t.timestamps null: false
    end
  end
end