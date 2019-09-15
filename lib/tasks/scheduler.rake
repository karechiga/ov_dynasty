desc "This task is called by the Heroku scheduler add-on"
task :update_players_list => :environment do
  def get_player_info
    response = Unirest.get "https://api-nba-v1.p.rapidapi.com/players/league/standard",
      {
        "X-RapidAPI-Host" => ENV["rapidapi_host"],
        "X-RapidAPI-Key" => ENV["rapidapi_key"]
      }
    return response.body
  end
  
  def get_team_info
    response = Unirest.get "https://api-nba-v1.p.rapidapi.com/teams/league/standard",
      {
        "X-RapidAPI-Host" => ENV["rapidapi_host"],
        "X-RapidAPI-Key" => ENV["rapidapi_key"]
      }
    return response.body
  end
  
  def team_id_is_valid(team_id)
    return !(NbaTeam.where(:id => team_id).empty?)
  end
  
  def team_is_valid(team)
    return team["nbaFranchise"] == "1"
  end
  
  def team_is_in_db(team)
    return !NbaTeam.where(:id => team["teamId"]).empty?
  end
  
  def player_is_valid(player)
    return player["leagues"]["standard"]["active"] == "1" && player["affiliation"] != "" && player["heightInMeters"] != "" && player["weightInKilograms"] != ""
  end
  
  def player_is_in_db(player)
    return !Player.where(:id => player["playerId"]).empty?
  end
  
  
  
  def create_player(player)
    name = "#{player["firstName"]} #{player["lastName"]}"
    team_id = player["teamId"]
    height_inches_float = player["heightInMeters"].to_f * 39.3701
    height_inches = height_inches_float.round
    height_feet = (height_inches / 12).floor
    weight_pounds = player["weightInKilograms"].to_f * 2.205
    college = player["collegeName"] == "No College" ? player["affiliation"] : player["collegeName"]
    position = player["leagues"]["standard"]["pos"]
    # if team_id == nil
    Player.create(name: name, first_name: player["firstName"], last_name: player["lastName"], id: player["playerId"], 
      nba_team_id: player["teamId"], years_pro: player["yearsPro"], college: college, country: player["country"],
        date_of_birth: player["dateOfBirth"], height_feet: height_feet, height_inches: height_inches, 
        weight_pounds: weight_pounds, position: position)
    puts "#{name}, #{height_feet}'#{height_inches % 12}"" Position: #{position}." 
    # elsif team_id_is_valid(team_id)
    #   NbaTeam.find(team_id).players.create(name: name, first_name: player["firstName"], last_name: player["lastName"], id: player["playerId"], nba_team_id: player["teamId"])
    #   puts "#{name} (#{NbaTeam.find(team_id).abbrev})"
    # end
  end
  
  def update_player(player)
    player_db = Player.find(player["playerId"])
  # if !player_is_up_to_date(player_db, player)
    name = "#{player["firstName"]} #{player["lastName"]}"
    team_id = player["teamId"].to_i
    height_inches_float = player["heightInMeters"].to_f * 39.3701
    height_inches = height_inches_float.round
    height_feet = (height_inches / 12).floor
    weight_pounds = player["weightInKilograms"].to_f * 2.205
    college = player["collegeName"] == "No College" ? player["affiliation"] : player["collegeName"]
    position = player["leagues"]["standard"]["pos"]
    position = position.to_s.gsub('-', ', ')
    puts "Updating #{player['firstName']} #{player['lastName']}, #{position}"
    player_db.update(name: name, first_name: player["firstName"], last_name: player["lastName"], id: player["playerId"], 
      nba_team_id: player["teamId"], years_pro: player["yearsPro"], college: college, country: player["country"],
        date_of_birth: player["dateOfBirth"], height_feet: height_feet, height_inches: height_inches, 
        weight_pounds: weight_pounds, position: position)
    # end
  end
  
  def destroy_player(player)
    puts "Destroying #{player['firstName']} #{player['lastName']}"
    Player.find(player["playerId"]).destroy
  end
  
  def update_players_list
    team_response = get_team_info
    player_response = get_player_info
    team_response["api"]["teams"].each do |team|
      if team_is_valid(team) && !team_is_in_db(team)
        nba_team = NbaTeam.create(city: team["city"], nickname: team["nickname"], abbrev: team["shortName"], id: team["teamId"])
        puts "#{nba_team.city} #{nba_team.nickname}"
      elsif team_is_valid(team)
        nba_team = NbaTeam.find(team["teamId"])
        puts "Already in database: #{nba_team.city} #{nba_team.nickname}"
      end
    end
  
    player_response["api"]["players"].each do |player|
      if player_is_valid(player) && !player_is_in_db(player)
        create_player(player)
      elsif player_is_valid(player)
        update_player(player)
      elsif player_is_in_db(player)
        destroy_player(player)
      end
    end
  end
  
  
  update_players_list
end

task :update_salaries => :environment do
  require 'nokogiri'
  require 'open-uri'
  require 'pry'
  require 'fuzzy_match'
  require 'amatch'

  include Amatch

  def data_scraper(url)
    Nokogiri::HTML(open(url))
  end

  def get_data(team_name)
    base_url = 'http://www.spotrac.com/nba/'
    main_url = "#{base_url}#{team_name}/yearly/base/roster/"
    return data_scraper(main_url)
  end

  def get_salaries(team_name)
      data = get_data(team_name)
      i = 1
      next_player = data.css("table:first-of-type > tbody > tr:nth-child(#{i}) > td > a")
      while !next_player.empty?
        player = data.css("table:first-of-type > tbody > tr:nth-child(#{i}) > td > a")
        salary_info = data.css("table:first-of-type > tbody > tr:nth-child(#{i}) > td:nth-child(3) > span")
        name = player.children.to_s
        salary = salary_info.children.to_s.gsub(/[^\d\.]/, '').to_f
        # puts "#{name} has a salary of #{salary}."
        if !Player.where("name like ?", "%#{name}%").empty?
          # puts "Found #{name} in the database"
          Player.where("name like ?", "%#{name}%")[0].update(:current_salary => salary)
          @matched.push(Player.where("name like ?", "%#{name}%")[0])
        else
          @unmatched.push(name)
          @unmatched_salaries.push(salary)
          # puts "Spotrac: #{name} Actual Name: #{fz_player.name} Distance: #{dist}"
        end
        i += 1
        next_player = data.css("table:first-of-type > tbody > tr:nth-child(#{i}) > td > a")
      end
  end


  teams = NbaTeam.all
  @matched = []
  @unmatched = []
  @unmatched_salaries = []
  teams.each do |team|
    city = team.city
    nickname = team.nickname
    if team.city == "LA"
      city = "Los Angeles"
    end
    team_name = "#{city} #{nickname}"
    team_name = team_name.gsub(" ", "-").downcase
    # puts team_name
    get_salaries(team_name)
  end
  players = Player.all
  unmatched_db = []
  players.each do |player|
    if @matched.index(player) == nil
      unmatched_db.push(player)
    end
  end

  fz = FuzzyMatch.new(unmatched_db, :read => :name)
  fz_last = FuzzyMatch.new(unmatched_db, :read => :last_name)
  @unmatched.each_index do |i|
    name = @unmatched[i]
    salary = @unmatched_salaries[i]
    fz_player = fz.find(name)
    name_arr = name.split(' ')
    last_name = name
    if name_arr.length == 2
      last_name = name_arr[1]
    elsif name_arr.length == 3
      last_name = "#{name_arr[1]} #{name_arr[2]}"
    end

    m = JaroWinkler.new(last_name)
    ls_dist = name.longest_substring_similar(fz_player.name)
    last_name_dist = m.match(fz_player.last_name)
    if ls_dist > 0.35 && last_name_dist > 0.9
      fz_player.update(:current_salary => salary)
      puts "Spotrac: #{name} Actual Name: #{fz_player.name} LS_Distance: #{ls_dist}, Last Name: #{last_name}, Jaro_Distance: #{last_name_dist}"
      puts "Updating #{fz_player.name}'s current salary to #{fz_player.current_salary}"
    else
      puts "Name is not found: #{name}, what FuzzyMatch thought: #{fz_player.name}, LS_Distance: #{ls_dist}, Last Name: #{last_name}, Jaro_Distance: #{last_name_dist}"
    end
  end

end

task :update_100_players_stats => :environment do
  def get_player_info(id)
    response = Unirest.get "https://api-nba-v1.p.rapidapi.com/statistics/players/playerId/#{id}",
      {
        "X-RapidAPI-Host" => ENV["rapidapi_host"],
        "X-RapidAPI-Key" => ENV["rapidapi_key"]
      }
    return response.body
  end

  def get_game_info(year)
    response = Unirest.get "https://api-nba-v1.p.rapidapi.com/games/seasonYear/#{year}",
      {
        "X-RapidAPI-Host" => ENV["rapidapi_host"],
        "X-RapidAPI-Key" => ENV["rapidapi_key"]
      }
    return response.body
  end

  def stats_populated_already(player)
    return player.gp != 0 && player.pts_total != 0
  end

  def minutes_string_to_float(minutes_seconds)
    strs = minutes_seconds.split(':')
    if strs.length == 1
      return minutes_seconds.to_f
    end
    minutes = strs[0].to_f
    seconds = strs[1].to_f
    return minutes + seconds / 60.0
  end

  def stats_initialize_to_zero(player)
    player.gp = 0
    player.min_total = 0.0
    player.pts_total = 0
    player.reb_total = 0
    player.ast_total = 0
    player.stl_total = 0
    player.blk_total = 0
    player.to_total = 0
    player.fgm_total = 0
    player.fga_total = 0
    player.fgm3_total = 0
    player.fga3_total = 0
    player.ftm_total = 0
    player.fta_total = 0
    return
  end

  def increment_stats(player, game_stats)
    player.gp += 1
    player.min_total += minutes_string_to_float(game_stats["min"])
    player.pts_total += game_stats["points"].to_i
    player.reb_total += game_stats["totReb"].to_i
    player.ast_total += game_stats["assists"].to_i
    player.stl_total += game_stats["steals"].to_i
    player.blk_total += game_stats["blocks"].to_i
    player.to_total += game_stats["turnovers"].to_i
    player.fgm_total += game_stats["fgm"].to_i
    player.fga_total += game_stats["fga"].to_i
    player.fgm3_total += game_stats["tpm"].to_i
    player.fga3_total += game_stats["tpa"].to_i
    player.ftm_total += game_stats["ftm"].to_i
    player.fta_total += game_stats["fta"].to_i
  end

  def update_per_game(player)
    player.mpg = player.calc_mpg
    player.ppg = player.calc_ppg
    player.rpg = player.calc_rpg
    player.apg = player.calc_apg
    player.spg = player.calc_spg
    player.bpg = player.calc_bpg
    player.topg = player.calc_topg
    player.fg_perc = player.calc_fg_perc
    player.fg3_perc = player.calc_fg3_perc
    player.ft_perc = player.calc_ft_perc
    player.fppg = player.calc_fppg
  end

  game_response = get_game_info(2018)
  games = game_response["api"]["games"]
  # games = games.uniq! { |game| [game["startTimeUTC"], game["endTimeUTC"], game["arena"]] }
  games.delete_if { |game| game["seasonStage"] != "2" || game["league"] != "standard" } 
  
  players = Player.all.sort_by { |player| player.last_name }
  # i = players.index { |player| player.first_name == "Nene" }
  for i in 51..100 do
    if !stats_populated_already(players[i])
      puts "updating stats for #{players[i].name}"
      stats_initialize_to_zero(players[i])

      player_response = get_player_info(players[i].id)
    
      player_response["api"]["statistics"].each do |game_stats|
        game_index = games.index { |game| game["gameId"] == game_stats["gameId"] && game_stats["min"] != "0:00" && game_stats["min"] != ""}
        if game_index != nil
          increment_stats(players[i], game_stats)
        end
      end
      update_per_game(players[i])
      players[i].save
    end
  end

  # for i in 0..70 do
    
  # end
end

task :reset_stats => :environment do

  def set_to_nil(player)
    player.gp = nil
    player.min_total = nil
    player.pts_total = nil
    player.reb_total = nil
    player.ast_total = nil
    player.stl_total = nil
    player.blk_total = nil
    player.to_total = nil
    player.fgm_total = nil
    player.fga_total = nil
    player.fgm3_total = nil
    player.fga3_total = nil
    player.ftm_total = nil
    player.fta_total = nil
  end

  players = Player.all
  players.each do |player|
    set_to_nil(player)
    player.save
  end
end

task :remove_players_from_roster => :environment do
  players = Player.where.not(roster_id: nil)
  players.each do |player| 
    player.update(:roster_id => nil)
  end
end