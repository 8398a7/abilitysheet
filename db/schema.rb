# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_30_141745) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.bigint "sheet_id"
    t.float "fc"
    t.float "exh"
    t.float "h"
    t.float "c"
    t.float "e"
    t.float "aaa"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["sheet_id"], name: "index_abilities_on_sheet_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "target_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "target_user_id"], name: "index_follows_on_user_id_and_target_user_id", unique: true
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "sheet_id"
    t.integer "pre_state"
    t.integer "new_state"
    t.integer "pre_score"
    t.integer "new_score"
    t.integer "pre_bp"
    t.integer "new_bp"
    t.integer "version"
    t.date "created_date"
    t.index ["created_date", "user_id", "sheet_id"], name: "index_logs_on_created_date_and_user_id_and_sheet_id", unique: true
    t.index ["sheet_id"], name: "index_logs_on_sheet_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "body"
    t.string "email"
    t.inet "ip", null: false
    t.bigint "user_id"
    t.boolean "state", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "state", default: 7, null: false
    t.integer "score"
    t.integer "bp"
    t.bigint "sheet_id", null: false
    t.bigint "user_id", null: false
    t.integer "version", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["sheet_id"], name: "index_scores_on_sheet_id"
    t.index ["updated_at"], name: "index_scores_on_updated_at"
    t.index ["user_id", "version", "updated_at"], name: "index_scores_on_user_id_and_version_and_updated_at"
    t.index ["user_id"], name: "index_scores_on_user_id"
    t.index ["version", "sheet_id", "user_id"], name: "index_scores_on_version_and_sheet_id_and_user_id", unique: true
  end

  create_table "sheets", force: :cascade do |t|
    t.string "title"
    t.integer "n_ability"
    t.integer "h_ability"
    t.integer "version"
    t.boolean "active", default: true, null: false
    t.string "textage"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "exh_ability"
  end

  create_table "socials", force: :cascade do |t|
    t.string "provider"
    t.json "raw"
    t.string "secret"
    t.string "token"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "provider"], name: "index_socials_on_user_id_and_provider", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "iidxid", null: false
    t.integer "version", default: 22, null: false
    t.string "djname", null: false
    t.integer "grade"
    t.integer "pref", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["iidxid"], name: "index_users_on_iidxid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
