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

ActiveRecord::Schema[7.0].define(version: 2024_01_08_183226) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.string "answer"
    t.integer "category_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_questions_on_category_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "quiz_answers", force: :cascade do |t|
    t.integer "quiz_session_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.string "text"
    t.boolean "correct"
    t.index ["question_id"], name: "index_quiz_answers_on_question_id"
    t.index ["quiz_session_id", "question_id", "user_id"], name: "quiz_answers_unique_index", unique: true
    t.index ["quiz_session_id"], name: "index_quiz_answers_on_quiz_session_id"
    t.index ["user_id"], name: "index_quiz_answers_on_user_id"
  end

  create_table "quiz_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "questions_count"
    t.string "status", default: "pending"
    t.string "session_type", default: "default"
    t.integer "current_question_index", default: 0
    t.index ["user_id"], name: "index_quiz_sessions_on_user_id"
  end

  create_table "sessions_players", force: :cascade do |t|
    t.integer "quiz_session_id", null: false
    t.integer "user_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_session_id"], name: "index_sessions_players_on_quiz_session_id"
    t.index ["user_id"], name: "index_sessions_players_on_user_id"
  end

  create_table "sessions_questions", force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "quiz_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_sessions_questions_on_question_id"
    t.index ["quiz_session_id"], name: "index_sessions_questions_on_quiz_session_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "users"
  add_foreign_key "questions", "categories"
  add_foreign_key "questions", "users"
  add_foreign_key "quiz_answers", "questions"
  add_foreign_key "quiz_answers", "quiz_sessions"
  add_foreign_key "quiz_answers", "users"
  add_foreign_key "quiz_sessions", "users"
  add_foreign_key "sessions_players", "quiz_sessions"
  add_foreign_key "sessions_players", "users"
  add_foreign_key "sessions_questions", "questions"
  add_foreign_key "sessions_questions", "quiz_sessions"
end
