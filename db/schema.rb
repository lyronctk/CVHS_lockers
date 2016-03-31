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

ActiveRecord::Schema.define(version: 20160331021059) do

  create_table "cvhs_lockers", force: :cascade do |t|
    t.string   "name1"
    t.string   "name2"
    t.integer  "studentID1"
    t.integer  "studentID2"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "pref1"
    t.integer  "pref2"
    t.integer  "pref3"
    t.string   "lastName1"
    t.string   "lastName2"
    t.integer  "lockerNum"
    t.string   "buildingNum"
    t.string   "locker_unique"
  end

  create_table "lockers_dbs", force: :cascade do |t|
    t.string   "building"
    t.integer  "unique"
    t.integer  "locker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restrictions", force: :cascade do |t|
    t.string   "floors"
    t.integer  "grades"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "full_buildings"
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "student_id"
    t.integer  "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
