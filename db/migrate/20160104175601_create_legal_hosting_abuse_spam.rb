class CreateLegalHostingAbuseSpam < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_spam do |t|
      t.integer :report_id
      t.integer :detection_method_id
      t.integer :content_type_id
      t.integer :outgoing_emails_queue
      t.integer :recepients_per_email
      t.integer :bounced_emails_queue
      t.integer :sent_emails_count
      t.date    :sent_emails_start_date
      t.date    :sent_emails_end_date
      t.text    :logs
      t.string  :other_detection_method
      t.text    :header
      t.text    :body
      t.text    :bounce
      t.text    :example_complaint
      t.boolean :experts_enabled
      t.boolean :ip_is_blacklisted
      t.string  :blacklisted_ip
      t.boolean :sent_by_cpanel
      t.integer :involved_mailboxes_count
      t.boolean :mailbox_password_reset
      t.text    :involved_mailboxes
      t.text    :mailbox_password_reset_reason
      t.integer :involved_mailboxes_count_other
      t.string  :reported_ip
      t.boolean :reported_ip_blacklisted
      
      t.timestamps null: false
    end
  end
end