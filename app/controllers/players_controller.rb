class PlayersController < ApplicationController

  def create
    @player = Player.create(player_params)
  end

  def update
    @player = Player.find(params[:id])
    @player = Player.update_attributes(player_params)
  end

  def show
  end

  def index
    @players = Player.all
  end

  private

  def player_params
    params.require(:player).permit(:id, :position,
      :name, :first_name, :last_name, :gp, :min_total, :pts_total,
      :reb_total, :ast_total, :stl_total, :blk_total,
      :to_total, :fgm_total, :fga_total, :fgm3_total,
      :fga3_total, :ftm_total, :fta_total, :roster_id, 
      :nba_team_id)
  end
end
