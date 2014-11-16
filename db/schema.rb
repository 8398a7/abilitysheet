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

ActiveRecord::Schema.define(version: 20141116153743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "logs", force: true do |t|
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

  create_table "notices", force: true do |t|
    t.string  "body"
    t.integer "state"
    t.boolean "active"
    t.date    "created_at"
  end

  create_table "scores", force: true do |t|
    t.integer  "state",      default: 7, null: false
    t.integer  "score"
    t.integer  "bp"
    t.integer  "sheet_id",               null: false
    t.integer  "user_id",                null: false
    t.integer  "version",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["sheet_id"], name: "index_scores_on_sheet_id", using: :btree
  add_index "scores", ["user_id"], name: "index_scores_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",               default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "iidxid",                              null: false
    t.integer  "version",                default: 22, null: false
    t.string   "djname",                              null: false
    t.integer  "grade"
    t.integer  "pref",                                null: false
    t.text     "rival"
    t.text     "reverse_rival"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["iidxid"], name: "index_users_on_iidxid", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
