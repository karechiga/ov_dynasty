class LeaguesController < ApplicationController
  before_action :authenticate_user!

  def index
    @leagues = League.all
  end

  def show
    @league = current_user.leagues.find(params[:id])
  end

  def new
    @league = League.new
  end

  def create
    if user_signed_in?
      @league = current_user.leagues.create(league_params)
      redirect_to league_path(@league)
    else
      redirect_to new_user_session_path and return
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :motto, :num_teams)
  end
end
