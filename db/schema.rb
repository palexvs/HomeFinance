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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120902183023) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "currency",    :limit => 3,                :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "balance",                  :default => 0, :null => false
    t.integer  "user_id"
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name", :unique => true
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "sid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["sid"], :name => "index_sessions_on_sid", :unique => true
  add_index "sessions", ["user_id"], :name => "index_sessions_on_user_id"

  create_table "transaction_types", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "transactions", :force => true do |t|
    t.string   "text"
    t.integer  "amount_cents"
    t.date     "date"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "transaction_type_id",                :null => false
    t.integer  "account_id",          :default => 1, :null => false
    t.integer  "user_id"
    t.integer  "trans_account_id"
    t.integer  "trans_amount_cents"
  end

  add_index "transactions", ["account_id"], :name => "index_transactions_on_account_id"
  add_index "transactions", ["trans_account_id"], :name => "index_transactions_on_trans_account_id"
  add_index "transactions", ["transaction_type_id"], :name => "index_transactions_on_type_id"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
