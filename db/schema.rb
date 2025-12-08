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

ActiveRecord::Schema[8.0].define(version: 2025_12_08_162100) do
  create_table "class_members", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "klass_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["klass_id"], name: "index_class_members_on_klass_id"
    t.index ["user_id"], name: "index_class_members_on_user_id"
  end

  create_table "form_answers", force: :cascade do |t|
    t.integer "form_response_id", null: false
    t.integer "form_template_field_id", null: false
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_response_id"], name: "index_form_answers_on_form_response_id"
    t.index ["form_template_field_id"], name: "index_form_answers_on_form_template_field_id"
  end

  create_table "form_responses", force: :cascade do |t|
    t.integer "form_id", null: false
    t.integer "user_id", null: false
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_form_responses_on_form_id"
    t.index ["user_id"], name: "index_form_responses_on_user_id"
  end

  create_table "form_template_fields", force: :cascade do |t|
    t.integer "form_template_id", null: false
    t.string "field_type"
    t.string "label"
    t.boolean "required"
    t.json "options"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_template_id"], name: "index_form_template_fields_on_form_template_id"
  end

  create_table "form_templates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_form_templates_on_user_id"
  end

  create_table "forms", force: :cascade do |t|
    t.integer "form_template_id", null: false
    t.integer "klass_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "due_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_template_id"], name: "index_forms_on_form_template_id"
    t.index ["klass_id"], name: "index_forms_on_klass_id"
  end

  create_table "klasses", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "semester"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "matricula"
    t.string "curso"
    t.string "formacao"
    t.string "ocupacao"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "class_members", "klasses"
  add_foreign_key "class_members", "users"
  add_foreign_key "form_answers", "form_responses"
  add_foreign_key "form_answers", "form_template_fields"
  add_foreign_key "form_responses", "forms"
  add_foreign_key "form_responses", "users"
  add_foreign_key "form_template_fields", "form_templates"
  add_foreign_key "form_templates", "users"
  add_foreign_key "forms", "form_templates"
  add_foreign_key "forms", "klasses"
end
