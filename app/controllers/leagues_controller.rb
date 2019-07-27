class LeaguesController < ApplicationController
  before_action :authenticate_user!

  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
  end

  def new
    @league = League.new
  end

  def create
    @league = current_user.leagues.create(league_params)
    redirect_to league_path(@league)
  end

  private

  def league_params
    params.require(:league).permit(:name, :motto, :num_teams)
  end
end
