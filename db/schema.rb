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

ActiveRecord::Schema.define(:version => 20110515230319) do

  create_table "comments", :force => true do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.string  "move"
    t.text    "text"
  end

  create_table "game_roles", :force => true do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.string  "role"
  end

  create_table "games", :force => true do |t|
    t.string   "scheduleable_type"
    t.string   "result"
    t.text     "pgn"
    t.date     "expected_start_date"
    t.datetime "actual_start_datetime"
    t.integer  "round"
    t.integer  "scheduleable_id"
  end

  create_table "leagues", :force => true do |t|
    t.string  "name"
    t.integer "round_length"
    t.string  "round_length_unit"
  end

  create_table "schedules", :force => true do |t|
    t.string  "name"
    t.integer "league_id"
  end

  create_table "tournament_games", :force => true do |t|
    t.integer "game_id"
    t.integer "predecessor1_id"
    t.integer "predecessor2_id"
  end

  create_table "tournaments", :force => true do |t|
    t.integer "league_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "record"
    t.float    "rating"
    t.integer  "league_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
