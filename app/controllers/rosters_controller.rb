class RostersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_membership
  before_action :require_user_roster_owner, only: :edit

  def show
    @roster = current_roster
    @roster_spots = @roster.roster_spots
    @players = @roster.players
    @picks = @roster.picks
    @player_associations = @roster.player_associations
    @season = current_season
    @years = years
  end

  def edit
    @roster = current_roster
  end

  def update
    @roster = current_roster
    @roster.update_attributes(roster_params)
    redirect_to league_roster_path(current_league, current_roster)
  end
  
  private

  def current_roster
    @roster = Roster.find(params[:id])
  end

  def current_league
    @current_league ||= League.find(params[:league_id])
  end
  
  def current_membership
    @current_membership = current_user.memberships.find_by_league_id(current_league)
  end

  def require_user_roster_owner
    if !current_user.owns_roster?(current_roster)
      render plain: "Unauthorized", status: :unauthorized
    end
  end
  
  def require_user_membership
    if !current_user.is_a_member?(current_league)
      render plain: "Unauthorized", status: :unauthorized
    end
  end
  def roster_params
    params.require(:roster).permit(:team_name, :team_abbrev, :motto)
  end

  def current_season
    month = Date.today.month
    year = Date.today.year
    if month < 6
      return year-1
    else
      return year
    end
  end

  def years
    years = []
    season = current_season + 1
    6.times do |i|
      years.push(season + i)
    end
    return years
  end

end
