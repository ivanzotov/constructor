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

ActiveRecord::Schema.define(:version => 20130609103268) do

  create_table "constructor_core_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "constructor_core_users", ["email"], :name => "index_constructor_core_users_on_email", :unique => true
  add_index "constructor_core_users", ["reset_password_token"], :name => "index_constructor_core_users_on_reset_password_token", :unique => true

  create_table "constructor_pages_boolean_types", :force => true do |t|
    t.boolean  "value",      :default => false
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "constructor_pages_date_types", :force => true do |t|
    t.date     "value",      :default => '2013-06-09'
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "constructor_pages_fields", :force => true do |t|
    t.string   "name"
    t.string   "code_name"
    t.string   "type_value"
    t.integer  "position"
    t.integer  "template_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "constructor_pages_float_types", :force => true do |t|
    t.float    "value",      :default => 0.0
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "constructor_pages_html_types", :force => true do |t|
    t.text     "value",      :limit => 4294967295, :default => ""
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "constructor_pages_image_types", :force => true do |t|
    t.string   "value_uid"
    t.string   "value_name"
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "constructor_pages_integer_types", :force => true do |t|
    t.integer  "value",      :default => 0
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "constructor_pages_pages", :force => true do |t|
    t.boolean  "active",                            :default => true
    t.string   "name",                              :default => ""
    t.boolean  "auto_url",                          :default => true
    t.string   "full_url",                          :default => ""
    t.string   "url",                               :default => ""
    t.string   "link",                              :default => ""
    t.string   "title",                             :default => ""
    t.string   "keywords",                          :default => ""
    t.text     "description", :limit => 4294967295, :default => ""
    t.boolean  "in_menu",                           :default => true
    t.boolean  "in_nav",                            :default => true
    t.boolean  "in_map",                            :default => true
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "template_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  create_table "constructor_pages_string_types", :force => true do |t|
    t.string   "value",      :default => ""
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "constructor_pages_templates", :force => true do |t|
    t.string   "name"
    t.string   "code_name"
    t.integer  "parent_id"
    t.integer  "child_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "constructor_pages_text_types", :force => true do |t|
    t.text     "value",      :limit => 4294967295, :default => ""
    t.integer  "field_id"
    t.integer  "page_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

end
