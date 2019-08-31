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

ActiveRecord::Schema.define(version: 2019_08_14_072729) do

  create_table "access_tokens", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "access_token", null: false
    t.integer "issued_at", null: false
    t.integer "expires_in", null: false
    t.integer "expire_time", null: false
    t.string "refresh_token", null: false
    t.integer "refresh_token_expires_in", null: false
    t.integer "refresh_token_expire_time", null: false
    t.integer "refresh_count", default: 0, null: false
    t.index ["refresh_token"], name: "ux__access_tokens__refresh_token", unique: true
    t.index ["user_id"], name: "fk__access_tokens__users__user_id"
  end

  create_table "point_card_collaborators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "point_card_id", null: false
    t.bigint "user_id", null: false
    t.string "permission", null: false
    t.index ["point_card_id", "user_id"], name: "ux__point_card_collaborators__point_card_id__user_id", unique: true
    t.index ["user_id"], name: "ix__point_card_collaborators__user_id"
  end

  create_table "point_card_issues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "point_card_id", null: false
    t.integer "no", null: false
    t.integer "point", default: 0, null: false
    t.index ["point_card_id", "no"], name: "ux__point_card_issues__point_card_id__no", unique: true
    t.index ["user_id", "point_card_id"], name: "ux__point_card_issues__user_id__point_card_id", unique: true
  end

  create_table "point_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "display_name", null: false
    t.text "description"
    t.integer "issue_count", default: 0, null: false
    t.string "image_url"
    t.index ["name"], name: "ux__point_cards__name", unique: true
  end

  create_table "point_collect_units", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "point_card_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "point", default: 0, null: false
    t.index ["point_card_id"], name: "fk__point_collect_units__point_cards__point_card_id"
  end

  create_table "point_issue_units", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "point_card_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "point", default: 0, null: false
    t.integer "expires_in"
    t.index ["point_card_id"], name: "fk__point_issue_units__point_cards__point_card_id"
  end

  create_table "points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "point_card_issue_id", null: false
    t.bigint "issued_by"
    t.datetime "issued_at", null: false
    t.integer "total", null: false
    t.integer "point", null: false
    t.boolean "expired"
    t.integer "expires_in"
    t.datetime "expired_at"
    t.integer "remaining_point"
    t.index ["issued_by"], name: "fk__points__users__issued_by"
    t.index ["point_card_issue_id"], name: "ix__points__point_card_issue_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "uid", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name"
    t.string "gender"
    t.date "date_of_birth"
    t.index ["email"], name: "ux__users__email", unique: true
    t.index ["uid"], name: "ux__users__uid", unique: true
  end

  add_foreign_key "access_tokens", "users", name: "fk__access_tokens__users__user_id"
  add_foreign_key "point_card_collaborators", "point_cards", name: "fk__point_card_collaborators__point_cards__point_card_id"
  add_foreign_key "point_card_collaborators", "users", name: "fk__point_card_collaborators__users__user_id"
  add_foreign_key "point_card_issues", "point_cards", name: "fk__point_card_issues__point_cards__point_card_id"
  add_foreign_key "point_card_issues", "users", name: "fk__point_card_issues__users__user_id"
  add_foreign_key "point_collect_units", "point_cards", name: "fk__point_collect_units__point_cards__point_card_id"
  add_foreign_key "point_issue_units", "point_cards", name: "fk__point_issue_units__point_cards__point_card_id"
  add_foreign_key "points", "point_card_issues", name: "fk__points__point_card_issues__point_card_issue_id"
  add_foreign_key "points", "users", column: "issued_by", name: "fk__points__users__issued_by"
end
