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

ActiveRecord::Schema[8.0].define(version: 2025_01_03_025407) do
  create_table "boosts", force: :cascade do |t|
    t.integer "group_id"
    t.text "original_status_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "original_status_uri"], name: "index_boosts_on_group_id_and_original_status_uri", unique: true
    t.index ["group_id"], name: "index_boosts_on_group_id"
  end

  create_table "followerships", force: :cascade do |t|
    t.integer "group_id"
    t.integer "remote_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "remote_account_id"], name: "index_followerships_on_group_id_and_remote_account_id", unique: true
  end

  create_table "forwards", force: :cascade do |t|
    t.integer "group_id"
    t.text "original_status_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "json", null: false
    t.index ["group_id", "original_status_uri"], name: "index_forwards_on_group_id_and_original_status_uri", unique: true
    t.index ["group_id"], name: "index_forwards_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "private_key", null: false
    t.text "public_key", null: false
    t.text "summary", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "remote_accounts", force: :cascade do |t|
    t.string "uri", null: false
    t.string "name", null: false
    t.string "domain", null: false
    t.string "public_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "inbox", null: false
    t.index ["domain", "name"], name: "index_remote_accounts_on_domain_and_name", unique: true
    t.index ["uri"], name: "index_remote_accounts_on_uri", unique: true
  end
end
