# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090915004208) do

  create_table "course_group_memberships", :force => true do |t|
    t.integer  "course_group_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_memberships", :force => true do |t|
    t.integer  "course_id"
    t.integer  "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_requirements", :force => true do |t|
    t.integer  "course_id"
    t.integer  "course_group_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "offered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "endpoint_requirements", :force => true do |t|
    t.integer  "endpoint_id"
    t.integer  "course_group_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "endpoints", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", :force => true do |t|
    t.integer  "plan_id"
    t.string   "season"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
