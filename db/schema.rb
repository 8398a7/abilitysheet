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

ActiveRecord::Schema.define(version: 20150703072925) do

  create_table "abilities", force: :cascade do |t|
    t.integer  "sheet_id",   limit: 4
    t.float    "fc",         limit: 24
    t.float    "exh",        limit: 24
    t.float    "h",          limit: 24
    t.float    "c",          limit: 24
    t.float    "e",          limit: 24
    t.float    "aaa",        limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "abilities", ["sheet_id"], name: "index_abilities_on_sheet_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "sheet_id",   limit: 4
    t.integer "pre_state",  limit: 4
    t.integer "new_state",  limit: 4
    t.integer "pre_score",  limit: 4
    t.integer "new_score",  limit: 4
    t.integer "pre_bp",     limit: 4
    t.integer "new_bp",     limit: 4
    t.integer "version",    limit: 4
    t.date    "created_at"
  end

  add_index "logs", ["sheet_id"], name: "index_logs_on_sheet_id", using: :btree
  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "body",       limit: 255
    t.string   "email",      limit: 255
    t.string   "ip",         limit: 255,                 null: false
    t.integer  "user_id",    limit: 4
    t.boolean  "state",                  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.string  "body",       limit: 255
    t.integer "state",      limit: 4
    t.boolean "active",                 default: true
    t.date    "created_at"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "state",      limit: 4, default: 7, null: false
    t.integer  "score",      limit: 4
    t.integer  "bp",         limit: 4
    t.integer  "sheet_id",   limit: 4,             null: false
    t.integer  "user_id",    limit: 4,             null: false
    t.integer  "version",    limit: 4,             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "scores", ["sheet_id"], name: "index_scores_on_sheet_id", using: :btree
  add_index "scores", ["updated_at"], name: "index_scores_on_updated_at", using: :btree
  add_index "scores", ["user_id"], name: "index_scores_on_user_id", using: :btree

  create_table "sheets", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "n_ability",  limit: 4
    t.integer  "h_ability",  limit: 4
    t.integer  "version",    limit: 4
    t.boolean  "active",                 default: true, null: false
    t.string   "textage",    limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "iidxid",                 limit: 255,                   null: false
    t.integer  "version",                limit: 4,     default: 22,    null: false
    t.string   "djname",                 limit: 255,                   null: false
    t.integer  "grade",                  limit: 4
    t.integer  "pref",                   limit: 4,                     null: false
    t.text     "rival",                  limit: 65535
    t.text     "reverse_rival",          limit: 65535
    t.boolean  "admin",                                default: false, null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "failed_attempts",        limit: 4,     default: 0,     null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
  end

  add_index "users", ["iidxid"], name: "index_users_on_iidxid", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
