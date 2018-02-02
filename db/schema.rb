# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180202113636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ability_permissions", force: :cascade do |t|
    t.integer  "resource_id"
    t.string   "identifier"
    t.string   "actions",     default: [],              array: true
    t.string   "conditions",  default: ""
    t.jsonb    "attrs",       default: {}
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "ability_permissions", ["identifier"], name: "index_ability_permissions_on_identifier", unique: true, using: :btree

  create_table "ability_resources", force: :cascade do |t|
    t.string   "subjects",   default: [],              array: true
    t.jsonb    "attrs",      default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "abuse_notes_infos", force: :cascade do |t|
    t.integer  "abuse_report_id"
    t.string   "reported_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "action"
  end

  create_table "abuse_report_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "abuse_reports", force: :cascade do |t|
    t.integer  "abuse_report_type_id"
    t.integer  "reported_by"
    t.integer  "processed_by"
    t.boolean  "processed",            default: false
    t.text     "comment"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "background_jobs", force: :cascade do |t|
    t.integer  "user_id"
    t.jsonb    "data"
    t.string   "status"
    t.string   "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "job_type"
    t.jsonb    "meta"
  end

  add_index "background_jobs", ["job_type"], name: "index_background_jobs_on_job_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "ddos_infos", force: :cascade do |t|
    t.integer  "abuse_report_id"
    t.integer  "registered_domains"
    t.integer  "free_dns_domains"
    t.boolean  "cfc_status",         default: false
    t.string   "cfc_comment"
    t.float    "amount_spent"
    t.date     "last_signed_in_on"
    t.string   "vendor_ticket_id"
    t.string   "client_ticket_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "impact",             default: "Low"
    t.string   "target_service",     default: "FreeDNS"
    t.boolean  "random_domains",     default: false
  end

  create_table "directory_group_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "directory_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_compensation_affected_products", force: :cascade do |t|
    t.string "name"
  end

  create_table "domains_compensation_issue_levels", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_compensation_logs", force: :cascade do |t|
    t.integer  "compensation_id"
    t.integer  "user_id"
    t.string   "action"
    t.jsonb    "payload"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "domains_compensation_tier_pricings", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_compensation_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_compensations", force: :cascade do |t|
    t.integer  "submitted_by_id"
    t.string   "reference_id"
    t.string   "reference_item"
    t.integer  "product_compensated_id"
    t.integer  "service_compensated_id"
    t.integer  "hosting_type_id"
    t.integer  "issue_level_id"
    t.integer  "compensation_type_id"
    t.boolean  "discount_recurring"
    t.float    "compensation_amount"
    t.integer  "tier_pricing_id"
    t.boolean  "client_satisfied"
    t.text     "comments"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status"
    t.integer  "checked_by_id"
    t.boolean  "used_correctly"
    t.boolean  "delivered"
    t.text     "qa_comments"
    t.string   "department"
    t.integer  "affected_product_id"
    t.datetime "checked_at"
  end

  create_table "domains_nc_hosting_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_nc_products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains_nc_services", force: :cascade do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "hosting_type_id"
    t.boolean  "hidden",          default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "legal_cfc_request_logs", force: :cascade do |t|
    t.integer  "request_id"
    t.integer  "user_id"
    t.string   "action"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_cfc_request_relations", force: :cascade do |t|
    t.integer "request_id"
    t.string  "username"
    t.integer "certainty"
    t.text    "comment"
  end

  create_table "legal_cfc_requests", force: :cascade do |t|
    t.integer  "submitted_by_id"
    t.integer  "processed_by_id"
    t.datetime "processed_at"
    t.integer  "status"
    t.string   "verification_ticket_id"
    t.string   "nc_username"
    t.date     "signup_date"
    t.integer  "request_type"
    t.integer  "find_relations_reason"
    t.string   "reference"
    t.integer  "service_type"
    t.string   "domain_name"
    t.string   "service_id"
    t.string   "pe_subscription"
    t.integer  "abuse_type"
    t.text     "other_description"
    t.integer  "service_status"
    t.string   "service_status_reference"
    t.text     "comments"
    t.boolean  "frauded"
    t.integer  "relations_status"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "verified_by_id"
    t.datetime "verified_at"
    t.text     "process_comments"
    t.integer  "investigation_approved_by_id"
    t.boolean  "investigate_unless_fraud"
    t.integer  "certainty_threshold"
    t.text     "recheck_reason"
    t.boolean  "abuse_deliberate"
  end

  add_index "legal_cfc_requests", ["nc_username"], name: "index_legal_cfc_requests_on_nc_username", using: :btree

  create_table "legal_cfc_requests_relations_types", force: :cascade do |t|
    t.integer "relation_id"
    t.string  "relation_type_uid"
  end

  add_index "legal_cfc_requests_relations_types", ["relation_id"], name: "index_legal_cfc_requests_relations_types_on_relation_id", using: :btree
  add_index "legal_cfc_requests_relations_types", ["relation_type_uid"], name: "index_legal_cfc_requests_relations_types_on_relation_type_uid", using: :btree

  create_table "legal_eforward_servers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse", force: :cascade do |t|
    t.integer  "reported_by_id"
    t.integer  "status",             default: 0
    t.integer  "service_id"
    t.integer  "type_id"
    t.integer  "server_id"
    t.integer  "efwd_server_id"
    t.integer  "ticket_id"
    t.integer  "nc_user_id"
    t.integer  "uber_service_id"
    t.string   "username"
    t.string   "resold_username"
    t.integer  "management_type_id"
    t.integer  "reseller_plan_id"
    t.integer  "shared_plan_id"
    t.integer  "vps_plan_id"
    t.string   "server_rack_label"
    t.string   "subscription_name"
    t.integer  "suggestion_id"
    t.text     "suspension_reason"
    t.string   "scan_report_path"
    t.text     "tech_comments"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "decision_id"
    t.text     "disregard_reason"
  end

  add_index "legal_hosting_abuse", ["subscription_name"], name: "index_legal_hosting_abuse_on_subscription_name", using: :btree
  add_index "legal_hosting_abuse", ["username"], name: "index_legal_hosting_abuse_on_username", using: :btree

  create_table "legal_hosting_abuse_ddos", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "block_type_id"
    t.boolean  "inbound"
    t.string   "domain_port"
    t.string   "other_block_type"
    t.string   "rule"
    t.text     "logs"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "legal_hosting_abuse_ddos_block_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_logs", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "user_id"
    t.string   "action"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_management_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_other", force: :cascade do |t|
    t.integer  "report_id"
    t.string   "domain_name"
    t.string   "url"
    t.text     "logs"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "legal_hosting_abuse_other_abuse_type_assignments", force: :cascade do |t|
    t.integer  "other_id"
    t.integer  "abuse_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "legal_hosting_abuse_other_abuse_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_pe_spam", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "detection_method_id"
    t.integer  "pe_content_type_id"
    t.text     "other_detection_method"
    t.integer  "sent_emails_amount"
    t.integer  "recepients_per_email"
    t.date     "sent_emails_start_date"
    t.date     "sent_emails_end_date"
    t.text     "example_complaint"
    t.boolean  "ip_is_blacklisted"
    t.string   "blacklisted_ip"
    t.string   "reported_ip"
    t.boolean  "reported_ip_blacklisted"
    t.integer  "postfix_deferred_queue"
    t.integer  "postfix_active_queue"
    t.integer  "mailer_daemon_queue"
    t.text     "header"
    t.text     "body"
    t.text     "bounce"
    t.boolean  "outbound_blocked"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "legal_hosting_abuse_pe_spam_queue_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_reseller_plans", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_resource", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "impact_id"
    t.integer  "type_id"
    t.integer  "upgrade_id"
    t.string   "other_measure"
    t.text     "details"
    t.text     "lve_report"
    t.text     "mysql_queries"
    t.text     "process_logs"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "db_governor_logs"
    t.string   "resource_consuming_websites", default: [],              array: true
    t.integer  "disk_abuse_type_id"
    t.string   "db_name"
    t.float    "db_size"
  end

  create_table "legal_hosting_abuse_resource_abuse_type_assignments", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "abuse_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "legal_hosting_abuse_resource_abuse_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_resource_activity_type_assignments", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "activity_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "legal_hosting_abuse_resource_activity_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_resource_disk_abuse_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legal_hosting_abuse_resource_file_type_assignments", force: :cascade do |t|
    t.integer "resource_id"
    t.integer "file_type_id"
  end

  create_table "legal_hosting_abuse_resource_file_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "legal_hosting_abuse_resource_impacts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_resource_measure_assignments", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "measure_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "legal_hosting_abuse_resource_measures", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_resource_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_resource_upgrades", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hidden",     default: false
  end

  create_table "legal_hosting_abuse_services", force: :cascade do |t|
    t.string   "name"
    t.jsonb    "properties", default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "legal_hosting_abuse_shared_plans", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_spam", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "detection_method_id"
    t.integer  "content_type_id"
    t.integer  "outgoing_emails_queue"
    t.integer  "recepients_per_email"
    t.integer  "bounced_emails_queue"
    t.integer  "sent_emails_count"
    t.date     "sent_emails_start_date"
    t.date     "sent_emails_end_date"
    t.text     "logs"
    t.text     "other_detection_method"
    t.text     "header"
    t.text     "body"
    t.text     "bounce"
    t.text     "example_complaint"
    t.boolean  "experts_enabled"
    t.boolean  "ip_is_blacklisted"
    t.string   "blacklisted_ip"
    t.boolean  "sent_by_cpanel"
    t.integer  "involved_mailboxes_count"
    t.boolean  "mailbox_password_reset"
    t.text     "involved_mailboxes"
    t.text     "mailbox_password_reset_reason"
    t.integer  "involved_mailboxes_count_other"
    t.string   "reported_ip"
    t.boolean  "reported_ip_blacklisted"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "legal_hosting_abuse_spam_content_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_spam_detection_methods", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_spam_pe_content_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_spam_pe_queue_type_assignments", force: :cascade do |t|
    t.integer  "pe_spam_id"
    t.integer  "pe_queue_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "legal_hosting_abuse_spam_pe_reporting_party_assignments", force: :cascade do |t|
    t.integer  "pe_spam_id"
    t.integer  "reporting_party_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "legal_hosting_abuse_spam_queue_type_assignments", force: :cascade do |t|
    t.integer  "spam_id"
    t.integer  "queue_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "legal_hosting_abuse_spam_queue_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_spam_reporting_parties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_spam_reporting_party_assignments", force: :cascade do |t|
    t.integer  "spam_id"
    t.integer  "reporting_party_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "legal_hosting_abuse_suggestions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_abuse_vps_plans", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_hosting_servers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legal_kayako_tickets", force: :cascade do |t|
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "legal_kayako_tickets", ["identifier"], name: "index_legal_kayako_tickets_on_identifier", using: :btree

  create_table "legal_pdf_reports", force: :cascade do |t|
    t.integer  "created_by_id"
    t.integer  "edited_by_id"
    t.string   "username"
    t.date     "expires_on"
    t.jsonb    "content",       default: {"order"=>[], "pages"=>{}}
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "legal_pdf_reports", ["created_by_id"], name: "index_legal_pdf_reports_on_created_by_id", using: :btree
  add_index "legal_pdf_reports", ["edited_by_id"], name: "index_legal_pdf_reports_on_edited_by_id", using: :btree
  add_index "legal_pdf_reports", ["username"], name: "index_legal_pdf_reports_on_username", using: :btree

  create_table "legal_uber_services", force: :cascade do |t|
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "legal_uber_services", ["identifier"], name: "index_legal_uber_services_on_identifier", using: :btree

  create_table "legal_user_relation_types", force: :cascade do |t|
    t.string "uid"
    t.string "name"
  end

  add_index "legal_user_relation_types", ["uid"], name: "index_legal_user_relation_types_on_uid", using: :btree

  create_table "nc_service_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nc_services", force: :cascade do |t|
    t.integer  "nc_user_id"
    t.integer  "nc_service_type_id"
    t.integer  "status_ids",         default: [],              array: true
    t.string   "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "nc_users", force: :cascade do |t|
    t.string   "username"
    t.integer  "status_ids",   default: [],              array: true
    t.date     "signed_up_on"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "role_id"
    t.string   "subject_class"
    t.string   "actions",                    array: true
    t.integer  "subject_ids",                array: true
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "private_email_infos", force: :cascade do |t|
    t.integer  "abuse_report_id"
    t.boolean  "suspended",         default: false
    t.string   "reported_by"
    t.string   "warning_ticket_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "hosting_abuse_id"
  end

  create_table "rbl_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rbls", force: :cascade do |t|
    t.integer  "rbl_status_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.json     "data",          default: {}
  end

  create_table "relation_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_assignment_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_assignments", force: :cascade do |t|
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.integer  "abuse_report_id"
    t.integer  "report_assignment_type_id"
    t.jsonb    "meta_data",                 default: {}
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "report_assignments", ["reportable_type", "reportable_id"], name: "index_report_assignments_on_reportable_type_and_reportable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_ids",                  default: [], array: true
    t.string   "permission_ids",             default: [], array: true
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sbl_infos", force: :cascade do |t|
    t.integer  "sbl_id"
    t.string   "ip_range"
    t.datetime "date"
    t.text     "info"
    t.boolean  "rokso"
    t.boolean  "active",            default: true
    t.boolean  "removal_requested"
    t.string   "complaint"
    t.boolean  "client_responded"
    t.text     "comment"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "service_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spammer_infos", force: :cascade do |t|
    t.integer  "abuse_report_id"
    t.integer  "registered_domains"
    t.integer  "abused_domains"
    t.integer  "locked_domains"
    t.integer  "abused_locked_domains"
    t.boolean  "cfc_status",            default: false
    t.string   "cfc_comment"
    t.float    "amount_spent"
    t.date     "last_signed_in_on"
    t.boolean  "responded_previously",  default: false
    t.string   "reference_ticket_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tools_internal_domains", force: :cascade do |t|
    t.string   "name"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.integer  "role_id"
    t.boolean  "auto_role",                          default: true
    t.string   "api_key"
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "watched_domains", force: :cascade do |t|
    t.string   "name"
    t.string   "status",                  array: true
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  create_table "whitelisted_addresses", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
