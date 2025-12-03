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

ActiveRecord::Schema[8.0].define(version: 2025_12_03_020419) do
  create_table "comments", force: :cascade do |t|
    t.integer "todo_id", null: false
    t.integer "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_comments_on_todo_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "subtasks", force: :cascade do |t|
    t.integer "todo_id", null: false
    t.string "title", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_subtasks_on_todo_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "todo_collaborations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "todo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["todo_id"], name: "index_todo_collaborations_on_todo_id"
    t.index ["user_id", "todo_id"], name: "index_todo_collaborations_on_user_id_and_todo_id", unique: true
    t.index ["user_id"], name: "index_todo_collaborations_on_user_id"
  end

  create_table "todo_tags", force: :cascade do |t|
    t.integer "todo_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_todo_tags_on_tag_id"
    t.index ["todo_id", "tag_id"], name: "index_todo_tags_on_todo_id_and_tag_id", unique: true
    t.index ["todo_id"], name: "index_todo_tags_on_todo_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.date "due_date", default: -> { "CURRENT_DATE" }, null: false
    t.integer "priority", default: 0, null: false
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "todos"
  add_foreign_key "comments", "users"
  add_foreign_key "subtasks", "todos"
  add_foreign_key "todo_collaborations", "todos"
  add_foreign_key "todo_collaborations", "users"
  add_foreign_key "todo_tags", "tags"
  add_foreign_key "todo_tags", "todos"
  add_foreign_key "todos", "users"
end
