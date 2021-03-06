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

ActiveRecord::Schema.define(version: 2020_01_31_032546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contract_years", force: :cascade do |t|
    t.string "season"
    t.decimal "salary"
    t.string "team_option", default: "false"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_association_id"
    t.index ["player_association_id"], name: "index_contract_years_on_player_association_id"
  end

  create_table "days", force: :cascade do |t|
    t.float "home_score", default: 0.0
    t.float "away_score", default: 0.0
    t.string "date"
    t.integer "matchup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_days_on_date"
    t.index ["matchup_id"], name: "index_days_on_matchup_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "date"
    t.integer "player_id"
    t.integer "min", default: 0
    t.integer "pts", default: 0
    t.integer "reb", default: 0
    t.integer "ast", default: 0
    t.integer "stl", default: 0
    t.integer "blk", default: 0
    t.integer "to", default: 0
    t.integer "fgm", default: 0
    t.integer "fga", default: 0
    t.integer "fgm3", default: 0
    t.integer "fga3", default: 0
    t.integer "ftm", default: 0
    t.integer "fta", default: 0
    t.integer "nba_game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_games_on_date"
    t.index ["nba_game_id"], name: "index_games_on_nba_game_id"
    t.index ["player_id"], name: "index_games_on_player_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.string "motto"
    t.integer "num_teams"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_leagues_on_user_id"
  end

  create_table "matchups", force: :cascade do |t|
    t.float "home_score", default: 0.0
    t.float "away_score", default: 0.0
    t.string "result", default: ""
    t.integer "schedule_id"
    t.integer "home_roster_id"
    t.integer "away_roster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "start_date"
    t.string "end_date"
    t.index ["end_date"], name: "index_matchups_on_end_date"
    t.index ["start_date"], name: "index_matchups_on_start_date"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["league_id"], name: "index_memberships_on_league_id"
    t.index ["user_id", "league_id"], name: "index_memberships_on_user_id_and_league_id"
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

  create_table "player_associations", force: :cascade do |t|
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "roster_spot_id"
    t.decimal "fppg"
    t.index ["player_id"], name: "index_player_associations_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "position"
    t.string "name"
    t.string "team"
    t.string "former_team"
    t.integer "gp", default: 0
    t.decimal "min_total", default: "0.0"
    t.integer "pts_total", default: 0
    t.integer "reb_total", default: 0
    t.integer "ast_total", default: 0
    t.integer "stl_total", default: 0
    t.integer "blk_total", default: 0
    t.integer "to_total", default: 0
    t.integer "fgm_total", default: 0
    t.integer "fga_total", default: 0
    t.integer "fgm3_total", default: 0
    t.integer "fga3_total", default: 0
    t.integer "ftm_total", default: 0
    t.integer "fta_total", default: 0
    t.string "timestamps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nba_team_id"
    t.string "first_name"
    t.string "last_name"
    t.decimal "current_salary", default: "0.0"
    t.integer "years_pro"
    t.string "college"
    t.string "country"
    t.string "date_of_birth"
    t.integer "height_feet"
    t.integer "height_inches"
    t.decimal "weight_pounds"
    t.decimal "mpg"
    t.decimal "ppg"
    t.decimal "rpg"
    t.decimal "apg"
    t.decimal "spg"
    t.decimal "bpg"
    t.decimal "topg"
    t.decimal "fg_perc"
    t.decimal "fg3_perc"
    t.decimal "ft_perc"
    t.string "primary_position"
    t.index ["college"], name: "index_players_on_college"
    t.index ["country"], name: "index_players_on_country"
    t.index ["date_of_birth"], name: "index_players_on_date_of_birth"
    t.index ["first_name"], name: "index_players_on_first_name"
    t.index ["last_name"], name: "index_players_on_last_name"
  end

  create_table "roster_salaries", force: :cascade do |t|
    t.integer "year"
    t.decimal "salary_cap", default: "0.0"
    t.decimal "traded_salary", default: "0.0"
    t.decimal "penalty", default: "0.0"
    t.decimal "salary_adds", default: "0.0"
    t.integer "roster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "salary_total", default: "0.0"
    t.decimal "player_salary_total", default: "0.0"
    t.index ["roster_id"], name: "index_roster_salaries_on_roster_id"
  end

  create_table "roster_spots", force: :cascade do |t|
    t.integer "roster_id"
    t.string "position", default: "Bench"
    t.decimal "salary_multiplier", default: "1.0"
    t.boolean "locked", default: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roster_id"], name: "index_roster_spots_on_roster_id"
  end

  create_table "rosters", force: :cascade do |t|
    t.string "team_name"
    t.string "team_abbrev"
    t.text "motto", default: ""
    t.integer "wins", default: 0
    t.integer "losses", default: 0
    t.integer "ties", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id"
    t.index ["league_id"], name: "index_rosters_on_league_id"
    t.index ["user_id"], name: "index_rosters_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "season"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
