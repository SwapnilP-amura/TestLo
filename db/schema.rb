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

ActiveRecord::Schema.define(version: 20161013082122) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employer_details", force: :cascade do |t|
    t.string   "company"
    t.string   "company_address"
    t.string   "contact"
    t.integer  "no_of_tests"
    t.integer  "active_tests"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "employer_id"
  end

  add_index "employer_details", ["employer_id"], name: "index_employer_details_on_employer_id"

  create_table "enrollments", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "test_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "score",      default: 0
    t.string   "response"
    t.boolean  "attempted",  default: false
    t.datetime "start_time"
  end

  add_index "enrollments", ["student_id"], name: "index_enrollments_on_student_id"
  add_index "enrollments", ["test_id"], name: "index_enrollments_on_test_id"

  create_table "questions", force: :cascade do |t|
    t.integer  "question_type"
    t.string   "question"
    t.string   "options"
    t.string   "correct_answer"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "category_id"
    t.integer  "employer_id"
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id"
  add_index "questions", ["employer_id"], name: "index_questions_on_employer_id"

  create_table "student_details", force: :cascade do |t|
    t.integer  "age"
    t.string   "college"
    t.string   "resume"
    t.integer  "experience"
    t.string   "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "student_id"
  end

  add_index "student_details", ["student_id"], name: "index_student_details_on_student_id"

  create_table "test_questions", force: :cascade do |t|
    t.integer  "test_id"
    t.integer  "question_id"
    t.integer  "marks",       default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "test_questions", ["question_id"], name: "index_test_questions_on_question_id"
  add_index "test_questions", ["test_id", "question_id"], name: "index_test_questions_on_test_id_and_question_id", unique: true
  add_index "test_questions", ["test_id"], name: "index_test_questions_on_test_id"

  create_table "tests", force: :cascade do |t|
    t.integer  "category"
    t.string   "name"
    t.date     "date"
    t.time     "duration"
    t.integer  "number_of_questions", default: 0
    t.integer  "marks",               default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "employer_id"
    t.boolean  "private",             default: true
    t.boolean  "active",              default: false
  end

  add_index "tests", ["employer_id"], name: "index_tests_on_employer_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "type"
    t.string   "username"
    t.string   "name"
    t.string   "phone_no"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
