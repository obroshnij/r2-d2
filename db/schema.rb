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

ActiveRecord::Schema.define(version: 20150306203929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "canned_parts", force: true do |t|
    t.integer  "canned_reply_id"
    t.string   "name"
    t.string   "dependency"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "canned_replies", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internal_accounts", force: true do |t|
    t.string   "username"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "internal_accounts", ["username"], name: "index_internal_accounts_on_username", unique: true, using: :btree

  create_table "reported_domains", force: true do |t|
    t.integer  "user_id"
    t.text     "domain_name"
    t.integer  "occurrences_count"
    t.text     "username"
    t.text     "email_address"
    t.text     "full_name"
    t.boolean  "dbl"
    t.boolean  "surbl"
    t.boolean  "blacklisted"
    t.text     "epp_status"
    t.text     "nameservers"
    t.text     "ns_record"
    t.text     "a_record"
    t.text     "mx_record"
    t.boolean  "vip_domain"
    t.boolean  "has_vip_domains"
    t.boolean  "spammer"
    t.boolean  "internal_account"
    t.boolean  "suspended_by_registry"
    t.boolean  "suspended_by_enom"
    t.boolean  "suspended_by_namecheap"
    t.boolean  "suspended_for_whois"
    t.boolean  "expired"
    t.boolean  "inactive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "spammers", force: true do |t|
    t.string   "username"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spammers", ["username"], name: "index_spammers_on_username", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vip_domains", force: true do |t|
    t.string   "domain"
    t.string   "username"
    t.string   "category"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vip_domains", ["domain"], name: "index_vip_domains_on_domain", unique: true, using: :btree

end
