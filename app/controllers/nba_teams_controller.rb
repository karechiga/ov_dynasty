class NbaTeamsController < ApplicationController

  def create
    @nba_team = NbaTeam.create(nba_team_params)
  end

  private

  def nba_team_params
    params.require(:nba_team).permit(:city, :nickname, :abbrev)
  end
end
