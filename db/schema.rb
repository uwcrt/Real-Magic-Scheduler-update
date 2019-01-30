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

ActiveRecord::Schema.define(version: 2017_04_24_024827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shift_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.float "primary_requirement"
    t.float "secondary_requirement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "ignore_primary", default: false
    t.boolean "ignore_suspended", default: false
    t.integer "critical_time", default: 7
    t.boolean "ignore_certs", default: false
    t.integer "limit", default: 0, null: false
  end

  create_table "shifts", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "start"
    t.datetime "finish"
    t.string "location", limit: 255
    t.integer "primary_id"
    t.integer "secondary_id"
    t.integer "shift_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.boolean "primary_disabled", default: false
    t.boolean "secondary_disabled", default: false
    t.integer "rookie_id"
    t.boolean "rookie_disabled", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "last_name", limit: 255
    t.boolean "admin", default: false
    t.boolean "disabled", default: false
    t.string "username", limit: 255, default: "", null: false
    t.string "authentication_token", limit: 255
    t.boolean "wants_notifications", default: false
    t.datetime "last_notified", default: "1970-01-01 00:00:00"
    t.date "sfa_expiry", default: "0001-01-01"
    t.date "hcp_expiry", default: "0001-01-01"
    t.integer "position", default: 0
    t.date "amfr_expiry", default: "0001-01-01"
    t.index ["username"], name: "index_users_on_username"
  end

end
