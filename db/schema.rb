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

ActiveRecord::Schema.define(:version => 20120314003853) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "currency",    :limit => 3,                :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "balance",                  :default => 0, :null => false
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name", :unique => true

  create_table "transaction_types", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "transactions", :force => true do |t|
    t.string   "text"
    t.integer  "amount"
    t.date     "date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "transaction_type_id", :null => false
    t.integer  "account_id",          :null => false
  end

  add_index "transactions", ["account_id"], :name => "index_transactions_on_account_id"
  add_index "transactions", ["transaction_type_id"], :name => "index_transactions_on_type_id"

end
