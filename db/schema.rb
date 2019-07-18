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

ActiveRecord::Schema.define(version: 2019_07_18_041951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.decimal "salaries", array: true
    t.integer "years"
    t.boolean "team_options", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
  end

  create_table "nba_teams", force: :cascade do |t|
    t.string "city"
    t.string "nickname"
    t.string "abbrev"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "picks", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.integer "round"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "roster_id"
    t.index ["name"], name: "index_picks_on_name"
    t.index ["round"], name: "index_picks_on_round"
    t.index ["year"], name: "index_picks_on_year"
  end

  create_table "players", force: :cascade do |t|
    t.string "position"
    t.string "name"
    t.string "team"
    t.string "former_team"
    t.integer "minutes"
    t.integer "points"
    t.integer "rebounds"
    t.integer "assists"
    t.integer "steals"
    t.integer "blocks"
    t.integer "turnovers"
    t.integer "fgm"
    t.integer "fga"
    t.integer "fgm3"
    t.integer "fga3"
    t.integer "ftm"
    t.integer "fta"
    t.integer "gp"
    t.integer "min_total"
    t.integer "pts_total"
    t.integer "reb_total"
    t.integer "ast_total"
    t.integer "stl_total"
    t.integer "blk_total"
    t.integer "to_total"
    t.integer "fgm_total"
    t.integer "fga_total"
    t.integer "fgm3_total"
    t.integer "fga3_total"
    t.integer "ftm_total"
    t.integer "fta_total"
    t.integer "roster_id"
    t.string "timestamps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nba_team_id"
    t.index ["roster_id"], name: "index_players_on_roster_id"
  end

  create_table "rosters", force: :cascade do |t|
    t.string "team_name"
    t.string "team_abbrev"
    t.text "motto"
    t.decimal "cap_space"
    t.decimal "penalty"
    t.decimal "traded_salary"
    t.integer "wins"
    t.integer "losses"
    t.integer "ties"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rosters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
