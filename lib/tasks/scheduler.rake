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
    if team_id == nil
      Player.create(name: name, first_name: player["firstName"], last_name: player["lastName"], id: player["playerId"], nba_team_id: player["teamId"])
      puts "#{name} (FA)"
    elsif team_id_is_valid(team_id)
      NbaTeam.find(team_id).players.create(name: name, first_name: player["firstName"], last_name: player["lastName"], id: player["playerId"], nba_team_id: player["teamId"])
      puts "#{name} (#{NbaTeam.find(team_id).abbrev})"
    end
  end
  
  def update_player(player)
    player_db = Player.find(player["playerId"])
    name = "#{player["firstName"]} #{player["lastName"]}"
    team_id = player["teamId"].to_i
    if player_db.name != name || player_db.nba_team_id != team_id
      puts "Updating #{player['firstName']} #{player['lastName']}"
      player_db.update(name: name, first_name: player["firstName"], last_name: player["lastName"], nba_team_id: team_id)
    end
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