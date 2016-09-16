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

ActiveRecord::Schema.define(version: 20160916023708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_links", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.boolean  "expires"
    t.datetime "expires_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["user_id"], name: "index_account_links_on_user_id", using: :btree
  end

  create_table "application_settings", force: :cascade do |t|
    t.boolean  "gitlab_enabled"
    t.string   "gitlab_url"
    t.string   "gitlab_id"
    t.string   "gitlab_secret"
    t.boolean  "github_enabled"
    t.string   "github_id"
    t.string   "github_secret"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "ga_tracking"
  end

  create_table "follows", force: :cascade do |t|
    t.string   "followable_type",                 null: false
    t.integer  "followable_id",                   null: false
    t.string   "follower_type",                   null: false
    t.integer  "follower_id",                     null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables", using: :btree
    t.index ["follower_id", "follower_type"], name: "fk_follows", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "coverage"
    t.string   "build_state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "origin"
    t.integer  "user_id"
    t.string   "description"
    t.boolean  "active"
    t.integer  "origin_id"
    t.string   "api_url"
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_admin"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "account_links", "users"
  add_foreign_key "projects", "users"
end
