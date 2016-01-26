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

ActiveRecord::Schema.define(version: 4) do

  create_table "badge_infos", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "created_by"
    t.boolean  "is_current"
    t.string   "version_start"
    t.string   "version_end"
    t.string   "version_range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badges", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "label"
    t.string   "title"
    t.string   "url"
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.integer  "uid"
    t.string   "handle"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_info_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
