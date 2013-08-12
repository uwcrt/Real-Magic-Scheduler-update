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

ActiveRecord::Schema.define(:version => 20130812011140) do

  create_table "shift_types", :force => true do |t|
    t.string   "name"
    t.float    "primary_requirement"
    t.float    "secondary_requirement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ignore_primary",        :default => false
    t.boolean  "ignore_suspended",      :default => false
    t.integer  "critical_time",         :default => 7
  end

  create_table "shifts", :force => true do |t|
    t.string   "name"
    t.datetime "start"
    t.datetime "finish"
    t.string   "location"
    t.integer  "primary_id"
    t.integer  "secondary_id"
    t.integer  "shift_type_id"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",        :limit => 255
    t.boolean  "aed",                               :default => true
    t.boolean  "vest",                              :default => false
    t.boolean  "primary_disabled",                  :default => false
    t.boolean  "secondary_disabled",                :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.boolean  "primary",              :default => false
    t.boolean  "admin",                :default => false
    t.boolean  "disabled",             :default => false
    t.string   "username",             :default => "",                    :null => false
    t.string   "authentication_token"
    t.boolean  "wants_notifications",  :default => false
    t.datetime "last_notified",        :default => '1970-01-01 05:00:00'
  end

  add_index "users", ["username"], :name => "index_users_on_username"

end
