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

ActiveRecord::Schema.define(:version => 20100329113324) do

  create_table "accounts", :force => true do |t|
    t.string   "ancestry"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "accounts", ["ancestry"], :name => "index_accounts_on_ancestry"
  add_index "accounts", ["type"], :name => "index_accounts_on_type"

  create_table "contacts", :force => true do |t|
    t.boolean  "self",                      :default => false
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
    t.string   "email"
    t.string   "phone_number"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchange_rates", :force => true do |t|
    t.string  "currency"
    t.decimal "rate",        :precision => 20, :scale => 4
    t.date    "recorded_on"
  end

  add_index "exchange_rates", ["currency"], :name => "index_exchange_rates_on_currency"
  add_index "exchange_rates", ["recorded_on"], :name => "index_exchange_rates_on_recorded_on"

  create_table "imports", :force => true do |t|
    t.integer  "account_id"
    t.string   "file_name"
    t.string   "message"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mapping_id"
    t.decimal  "ending_balance", :precision => 20, :scale => 4
  end

  create_table "ledger_items", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.date     "transacted_on"
    t.decimal  "total_amount"
    t.decimal  "tax_amount",                 :default => 0.0
    t.string   "currency",      :limit => 3,                  :null => false
    t.string   "description"
    t.string   "identifier"
    t.integer  "account_id"
    t.integer  "match_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ledger_items", ["account_id"], :name => "index_ledger_items_on_account_id"
  add_index "ledger_items", ["identifier"], :name => "index_ledger_items_on_identifier"
  add_index "ledger_items", ["recipient_id"], :name => "index_ledger_items_on_recipient_id"
  add_index "ledger_items", ["sender_id"], :name => "index_ledger_items_on_sender_id"
  add_index "ledger_items", ["total_amount"], :name => "index_ledger_items_on_total_amount"
  add_index "ledger_items", ["transacted_on"], :name => "index_ledger_items_on_transacted_on"

  create_table "mappings", :force => true do |t|
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
    t.boolean  "reverses_sign"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.integer  "new_sender_id"
    t.integer  "new_recipient_id"
    t.integer  "account_id"
    t.integer  "new_account_id"
    t.string   "matched_description"
    t.boolean  "matched_debit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matched_sender_id"
    t.integer  "matched_recipient_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
