class LeaguesController < ApplicationController
  before_action :authenticate_user!

  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
    if current_user.is_a_member?(@league)
      redirect_to league_homes_path(@league)
    end
  end

  def new
    @league = League.new
  end

  def create
    league = current_user.leagues.create(league_params)
    membership = current_user.memberships.create(league: league, admin: true)
    redirect_to league_homes_path(league)
  end

  private

  def league_params
    params.require(:league).permit(:name, :motto, :num_teams)
  end
end
