# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091025191438) do

  create_table "file_import_formats", :force => true do |t|
    t.string   "name"
    t.string   "currency",               :limit => 3
    t.integer  "date_row"
    t.integer  "total_amount_row"
    t.integer  "tax_amount_row"
    t.integer  "description_row"
    t.integer  "second_description_row"
    t.integer  "identifier_row"
    t.boolean  "has_title_row"
    t.boolean  "day_follows_month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ledger_accounts", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ledger_item_groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ledger_items", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.date     "issued_on"
    t.decimal  "total_amount",                      :precision => 20, :scale => 4
    t.decimal  "tax_amount",                        :precision => 20, :scale => 4
    t.string   "currency",             :limit => 3,                                :null => false
    t.string   "description"
    t.string   "identifier"
    t.integer  "ledger_account_id"
    t.integer  "ledger_item_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ledger_items", ["identifier"], :name => "index_ledger_items_on_identifier"
  add_index "ledger_items", ["issued_on"], :name => "index_ledger_items_on_issued_on"
  add_index "ledger_items", ["ledger_account_id"], :name => "index_ledger_items_on_ledger_account_id"
  add_index "ledger_items", ["recipient_id"], :name => "index_ledger_items_on_recipient_id"
  add_index "ledger_items", ["sender_id"], :name => "index_ledger_items_on_sender_id"
  add_index "ledger_items", ["total_amount"], :name => "index_ledger_items_on_total_amount"

  create_table "ledger_people", :force => true do |t|
    t.boolean  "is_self",                   :default => false
    t.string   "name"
    t.string   "contact_name"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "country_code", :limit => 2
    t.string   "tax_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_rules", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "ledger_account_id"
    t.integer  "matching_ledger_account_id"
    t.string   "description_matcher"
    t.boolean  "debit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
