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

ActiveRecord::Schema[7.0].define(version: 2023_10_03_111125) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "name"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["jti"], name: "index_admins_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "operator_id"
    t.bigint "user_id"
    t.string "pickup_date"
    t.string "pickup_time"
    t.integer "duration"
    t.string "return_date"
    t.integer "total_price"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "car_info"
    t.integer "car_id"
    t.index ["operator_id"], name: "index_bookings_on_operator_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "car_brand"
    t.string "car_name"
    t.string "fuel_type"
    t.string "transmission"
    t.integer "car_seats"
    t.string "car_type"
    t.string "coding_day"
    t.string "plate_number"
    t.json "location"
    t.json "images"
    t.integer "price"
    t.string "year"
    t.bigint "operator_id"
    t.boolean "reserved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operator_id"], name: "index_cars_on_operator_id"
  end

  create_table "operators", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "status", default: "pending"
    t.string "profile"
    t.integer "money", default: 0
    t.string "mobile"
    t.string "address"
    t.string "image_id"
    t.string "jti", null: false
    t.index ["email"], name: "index_operators_on_email", unique: true
    t.index ["jti"], name: "index_operators_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_operators_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "profile"
    t.integer "money", default: 0
    t.string "status", default: "pending"
    t.string "address"
    t.string "mobile"
    t.string "image_id"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "operators"
  add_foreign_key "bookings", "users"
  add_foreign_key "cars", "operators"
end
