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

ActiveRecord::Schema.define(version: 20150629090406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.integer  "sheet_id"
    t.float    "fc"
    t.float    "exh"
    t.float    "h"
    t.float    "c"
    t.float    "e"
    t.float    "aaa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "abilities", ["sheet_id"], name: "index_abilities_on_sheet_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sheet_id"
    t.integer "pre_state"
    t.integer "new_state"
    t.integer "pre_score"
    t.integer "new_score"
    t.integer "pre_bp"
    t.integer "new_bp"
    t.integer "version"
    t.date    "created_at"
  end

  add_index "logs", ["sheet_id"], name: "index_logs_on_sheet_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.string   "email"
    t.inet     "ip",                         null: false
    t.integer  "user_id"
    t.boolean  "state",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.string  "body"
    t.integer "state"
    t.boolean "active",     default: true
    t.date    "created_at"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "state",      default: 7, null: false
    t.integer  "score"
    t.integer  "bp"
    t.integer  "sheet_id",               null: false
    t.integer  "user_id",                null: false
    t.integer  "version",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "scores", ["sheet_id"], name: "index_scores_on_sheet_id", using: :btree
  add_index "scores", ["user_id"], name: "index_scores_on_user_id", using: :btree

  create_table "sheets", force: :cascade do |t|
    t.string   "title"
    t.integer  "n_ability"
    t.integer  "h_ability"
    t.integer  "version"
    t.boolean  "active",     default: true, null: false
    t.string   "textage"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "iidxid",                                 null: false
    t.integer  "version",                default: 22,    null: false
    t.string   "djname",                                 null: false
    t.integer  "grade"
    t.integer  "pref",                                   null: false
    t.text     "rival"
    t.text     "reverse_rival"
    t.boolean  "admin",                  default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["iidxid"], name: "index_users_on_iidxid", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
