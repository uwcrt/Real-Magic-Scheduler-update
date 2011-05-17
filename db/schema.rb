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

ActiveRecord::Schema.define(:version => 20110517002756) do

  create_table "shift_types", :force => true do |t|
    t.string   "name"
    t.float    "primary_requirement"
    t.float    "secondary_requirement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ignore_primary",        :default => false
    t.boolean  "ignore_suspended",      :default => false
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
    t.text     "description",   :limit => 255
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "last_name"
    t.boolean  "primary",            :default => false
    t.boolean  "admin",              :default => false
    t.boolean  "disabled",           :default => false
    t.boolean  "inactive",           :default => false
    t.boolean  "award",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
