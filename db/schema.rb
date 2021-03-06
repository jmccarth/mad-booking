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

ActiveRecord::Schema.define(version: 20141127192958) do

  create_table "bookings", force: true do |t|
    t.text     "schedule"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "sign_in_times"
    t.text     "sign_out_times"
    t.integer  "user_id"
    t.text     "comments"
    t.string   "creator"
  end

  create_table "bookings_equipment", id: false, force: true do |t|
    t.integer "booking_id"
    t.integer "equipment_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment", force: true do |t|
    t.string   "barcode"
    t.string   "name"
    t.string   "stored"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "category_id"
    t.integer  "status"
    t.string   "contents"
    t.string   "serial_number"
  end

  create_table "equipment_tags", id: false, force: true do |t|
    t.integer "equipment_id"
    t.integer "tag_id"
  end

  create_table "events", force: true do |t|
    t.integer  "booking_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.boolean  "admin"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "comments"
    t.string   "firstname"
    t.string   "lastname"
  end

end
