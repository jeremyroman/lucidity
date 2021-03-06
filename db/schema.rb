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

ActiveRecord::Schema.define(:version => 20110118023831) do

  create_table "catalogues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_memberships", :force => true do |t|
    t.integer  "course_id"
    t.integer  "term_id"
    t.boolean  "override"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "offered"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "catalogue_id"
    t.text     "requirements", :limit => 255
  end

  add_index "courses", ["code"], :name => "index_courses_on_code"

  create_table "plans", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["user_id"], :name => "index_plans_on_user_id"

  create_table "terms", :force => true do |t|
    t.string   "season"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
  end

  add_index "terms", ["plan_id"], :name => "index_terms_on_plan_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
