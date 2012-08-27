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

ActiveRecord::Schema.define(:version => 20120827150719) do

  create_table "shift_types", :force => true do |t|
    t.string    "name"
    t.float     "primary_requirement"
    t.float     "secondary_requirement"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "ignore_primary",        :default => false
    t.boolean   "ignore_suspended",      :default => false
    t.integer   "critical_time",         :default => 7
  end

  create_table "shifts", :force => true do |t|
    t.string    "name"
    t.timestamp "start"
    t.timestamp "finish"
    t.string    "location"
    t.integer   "primary_id"
    t.integer   "secondary_id"
    t.integer   "shift_type_id"
    t.string    "note"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.text      "description"
    t.boolean   "aed",           :default => true
    t.boolean   "vest",          :default => false
  end

  create_table "users", :force => true do |t|
    t.string    "first_name"
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "encrypted_password"
    t.string    "salt"
    t.string    "last_name"
    t.boolean   "admin"
    t.boolean   "primary"
    t.boolean   "disabled",           :default => false
    t.boolean   "inactive",           :default => false
    t.boolean   "award",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
