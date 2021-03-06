class MatchupsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_league
 
  def index
    @matchups = current_schedule.matchups.where(result: "active")
  end

  def show
    @matchup = Matchup.find(params[:id])
    @home_team = @matchup.home_team
    @away_team = @matchup.away_team
  end

  private
  
  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_season
    month = Date.today.month
    year = Date.today.year
    if month < 6
      return year - 1
    else
      return year
    end
  end

  def current_schedule
    @current_schedule ||= current_league.schedules.find_by_season(current_season)
  end

  def require_authorized_for_league
    if !current_user.is_a_member?(current_league)
      render plain: "Unauthorized", status: :unauthorized
    end
  end

end
