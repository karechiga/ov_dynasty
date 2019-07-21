# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)









def update_players_list
  team_response = get_team_info
  player_response = get_player_info
  team_response["api"]["teams"].each do |team|
    if team_is_valid(team)
      nba_team = NbaTeam.create(city: team["city"], nickname: team["nickname"], abbrev: team["shortName"], id: team["teamId"])
      puts "#{nba_team.city} #{nba_team.nickname}"
    elsif team["nbaFranchise"] == "1"
      nba_team = NbaTeam.find(team["teamId"])
      puts "Already in database: #{nba_team.city} #{nba_team.nickname}"
    end
  end
end

private

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

def team_is_valid(team)
  return NbaTeam.where(:id => team["teamId"]).empty? && team["nbaFranchise"] == "1"
end




# def get_player_info
#   response = Unirest.get "https://api-nba-v1.p.rapidapi.com/players/league/standard",
#     {
#       "X-RapidAPI-Host" => ENV["rapidapi_host"],
#       "X-RapidAPI-Key" => ENV["rapidapi_key"]
#     }
#   return response.body
# end

# def get_team_info
#   response = Unirest.get "https://api-nba-v1.p.rapidapi.com/teams/league/standard",
#     {
#       "X-RapidAPI-Host" => ENV["rapidapi_host"],
#       "X-RapidAPI-Key" => ENV["rapidapi_key"]
#     }
#   return response.body
# end

# def team_id_is_valid(team_id)
#   return !(NbaTeam.where(:id => team_id).empty?)
# end

# team_response = get_team_info
# player_response = get_player_info


# team_response["api"]["teams"].each do |team|
#   if team["nbaFranchise"] == "1"
#     nba_team = NbaTeam.create(city: team["city"], nickname: team["nickname"], abbrev: team["shortName"], id: team["teamId"])
#     puts "#{nba_team.city} #{nba_team.nickname}"
#   end
# end

# player_response["api"]["players"].each do |player|
#   if player["leagues"]["standard"]["active"] == "1"
#     name = "#{player["firstName"]} #{player["lastName"]}"
#     team_id = player["teamId"]
#     if team_id == nil
#       Player.create(name: name, id: player["playerId"], nba_team_id: player["teamId"])
#       puts "#{name} (FA)"
#     elsif team_id_is_valid(team_id)
#       NbaTeam.find(team_id).players.create(name: name, id: player["playerId"], nba_team_id: player["teamId"])
#       puts "#{name} (#{NbaTeam.find(team_id).abbrev})"
#     end
#   end
# end