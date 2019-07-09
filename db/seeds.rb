# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


def get_info
  response = Unirest.get "https://api-nba-v1.p.rapidapi.com/players/league/standard",
    {
      "X-RapidAPI-Host" => ENV["rapidapi_host"],
      "X-RapidAPI-Key" => ENV["rapidapi_key"]
    }
  return response.body
end


response = get_info

response["api"]["players"].each do |player|
  if player["leagues"]["standard"]["active"] == "1"
    name = "#{player["firstName"]} #{player["lastName"]}"
    puts name
    new_player = Player.create(name: name, id: player["playerId"])
    new_player.save
  end
end