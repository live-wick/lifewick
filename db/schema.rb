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

ActiveRecord::Schema.define(version: 2018_12_21_073018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "handshakes", force: :cascade do |t|
    t.string "dtype"
    t.boolean "notified"
    t.date "result_date"
    t.integer "status"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shares", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "shareable_id"
    t.string "shareable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strands", force: :cascade do |t|
    t.datetime "end_date"
    t.datetime "start_date"
    t.string "location"
    t.text "description"
    t.bigint "user_id"
    t.bigint "wick_id"
    t.integer "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_strands_on_user_id"
    t.index ["wick_id"], name: "index_strands_on_wick_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "alias"
    t.date "birth_date"
    t.string "last_name"
    t.string "first_name"
    t.boolean "open"
    t.string "user_name"
    t.string "work"
    t.string "subscription_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wicks", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wicks_on_user_id"
  end

  add_foreign_key "strands", "users"
  add_foreign_key "strands", "wicks"
  add_foreign_key "wicks", "users"
end
