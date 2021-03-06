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

ActiveRecord::Schema.define(:version => 20091104233239) do

  create_table "headers", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "response_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "response_codes", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", :force => true do |t|
    t.integer  "time"
    t.integer  "status"
    t.string   "reason"
    t.integer  "watch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string "name"
    t.string "css"
  end

  create_table "watches", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "last_response_time",    :default => 0
    t.integer  "warning_time"
    t.boolean  "active",                :default => true
    t.string   "content_match"
    t.integer  "expected_response",     :default => 200
    t.integer  "status_id",             :default => 1
    t.integer  "site_id"
    t.datetime "last_status_change_at"
    t.string   "status_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
