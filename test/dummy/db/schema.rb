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

ActiveRecord::Schema.define(:version => 20130401134830) do

  create_table "cardboard_collections", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cardboard_documents", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "collection_id"
    t.text     "fields_value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "cardboard_documents", ["collection_id"], :name => "index_cardboard_documents_on_collection_id"

  create_table "cardboard_field_groups", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "editable_form_id"
    t.string   "editable_form_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "cardboard_field_groups", ["editable_form_id"], :name => "index_cardboard_field_groups_on_editable_form_id"

  create_table "cardboard_fields", :force => true do |t|
    t.string   "element_name"
    t.string   "display_name"
    t.string   "type"
    t.boolean  "required"
    t.integer  "field_group_id"
    t.integer  "position"
    t.text     "value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "cardboard_fields", ["field_group_id"], :name => "index_cardboard_fields_on_field_group_id"

  create_table "cardboard_pages", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "slug"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cardboard_pages", ["url", "slug"], :name => "index_cardboard_pages_on_url_and_slug", :unique => true

end
