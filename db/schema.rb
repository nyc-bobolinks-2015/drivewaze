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

ActiveRecord::Schema.define(version: 20151212235145) do

  create_table "bookings", force: true do |t|
    t.integer  "total",                      null: false
    t.boolean  "paid",       default: false
    t.integer  "listing_id",                 null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "favorited_id"
    t.string   "favorited_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favorited_id", "favorited_type"], name: "index_favorites_on_favorited_id_and_favorited_type"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "listings", force: true do |t|
    t.string   "address",             null: false
    t.string   "space_description"
    t.string   "neighborhood_info"
    t.string   "public_transit_info"
    t.string   "other_info"
    t.string   "rules"
    t.integer  "user_id",             null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "parking_slots", force: true do |t|
    t.integer  "vehicle_class"
    t.integer  "slot_type"
    t.integer  "daily_price"
    t.integer  "weekly_price"
    t.integer  "monthly_price"
    t.integer  "listing_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.text     "review_body",     null: false
    t.integer  "review_score",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "time_slots", force: true do |t|
    t.boolean  "booked",          default: false
    t.boolean  "unavailable",     default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "parking_slot_id",                 null: false
    t.integer  "booking_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                               null: false
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "phone",                               null: false
    t.string   "zipcode"
    t.text     "description"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "publishable_key"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_code"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
