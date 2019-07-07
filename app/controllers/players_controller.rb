class PlayersController < ApplicationController

  def create
    @player = Player.create(player_params)
  end


  private

  def player_params
    params.require(:player).permit(:id, :position
      :name, :former_team, :minutes, :points,
      :rebounds, :assists, :steals, :blocks,
      :turnovers, :fgm, :fga, :fgm3, :fga3, 
      :ftm, :fta, :gp, :min_total, :pts_total,
      :reb_total, :ast_total, :stl_total, :blk_total,
      :to_total, :fgm_total, :fga_total, :fgm3_total,
      :fga3_total, :ftm_total, :fta_total, :roster_id)
  end
end
