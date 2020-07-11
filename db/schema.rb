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

ActiveRecord::Schema.define(version: 2020_07_11_142937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "forum_permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "forum_id", null: false
    t.boolean "moderator", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id"], name: "index_forum_permissions_on_forum_id"
    t.index ["user_id"], name: "index_forum_permissions_on_user_id"
  end

  create_table "forums", force: :cascade do |t|
    t.string "something_awful_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.string "name"
    t.index ["ancestry"], name: "index_forums_on_ancestry"
    t.index ["name"], name: "index_forums_on_name"
  end

  create_table "forums_something_awful_user_caches", force: :cascade do |t|
    t.bigint "forum_id"
    t.bigint "something_awful_user_cache_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id"], name: "index_forums_something_awful_user_caches_on_forum_id"
    t.index ["something_awful_user_cache_id"], name: "sa_user_cache_index"
  end

  create_table "server_permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "server_id", null: false
    t.boolean "moderator", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_server_permissions_on_server_id"
    t.index ["user_id"], name: "index_server_permissions_on_user_id"
  end

  create_table "servers", force: :cascade do |t|
    t.string "discord_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "something_awful_user_caches", force: :cascade do |t|
    t.string "name"
    t.string "something_awful_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "discord_id"
    t.string "something_awful_id"
    t.boolean "something_awful_verified", default: false, null: false
    t.string "discord_access_token"
    t.string "discord_refresh_token"
  end

end
