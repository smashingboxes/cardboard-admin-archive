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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130404192545) do

  create_table "cardboard_fields", :force => true do |t|
    t.string   "indentifier"
    t.string   "label"
    t.string   "type"
    t.boolean  "required"
    t.integer  "page_part_id"
    t.integer  "position"
    t.text     "value_uid"
    t.string   "hint"
    t.string   "placeholder"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "cardboard_fields", ["indentifier"], :name => "index_cardboard_fields_on_indentifier"
  add_index "cardboard_fields", ["page_part_id"], :name => "index_cardboard_fields_on_page_part_id"

  create_table "cardboard_page_parts", :force => true do |t|
    t.string   "identifier"
    t.integer  "position"
    t.boolean  "allow_multiple", :default => false
    t.string   "label"
    t.integer  "page_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "cardboard_page_parts", ["identifier"], :name => "index_cardboard_page_parts_on_identifier"
  add_index "cardboard_page_parts", ["page_id"], :name => "index_cardboard_page_parts_on_page_id"

  create_table "cardboard_pages", :force => true do |t|
    t.string   "title"
    t.string   "path"
    t.string   "slug"
    t.integer  "position"
    t.text     "meta_seo"
    t.string   "identifier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cardboard_pages", ["identifier"], :name => "index_cardboard_pages_on_identifier", :unique => true
  add_index "cardboard_pages", ["path", "slug"], :name => "index_cardboard_pages_on_path_and_slug", :unique => true

  create_table "cardboard_settings", :force => true do |t|
    t.string "name"
    t.text   "value"
    t.text   "default_value"
    t.text   "description"
    t.string "hint"
    t.string "format",        :default => "string"
  end

  add_index "cardboard_settings", ["name"], :name => "index_cardboard_settings_on_name"

  create_table "cardboard_users", :force => true do |t|
    t.string   "email",              :default => "", :null => false
    t.string   "encrypted_password", :default => "", :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "cardboard_users", ["email"], :name => "index_cardboard_users_on_email", :unique => true
  add_index "cardboard_users", ["unlock_token"], :name => "index_cardboard_users_on_unlock_token", :unique => true

  create_table "pianos", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
