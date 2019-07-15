class StaticPagesController < ApplicationController
  require 'unirest'


  def index
    # @response = get_info()
    @players = Player.all
  end

  private

  def get_info
    response = Unirest.get "https://api-nba-v1.p.rapidapi.com/games/live/",
      {
        "X-RapidAPI-Host" => ENV["rapidapi_host"],
        "X-RapidAPI-Key" => ENV["rapidapi_key"]
      }
    return response.body
  end

  
end
