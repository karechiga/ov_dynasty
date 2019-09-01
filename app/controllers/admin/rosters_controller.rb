class Admin::RostersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_admin_privilege

  def index
    @rosters = current_league.rosters
  end

  def show
    @roster = Roster.find(params[:id])
    @players = @roster.players
    @picks = @roster.picks
    @player_associations = @roster.player_associations
    @season = current_season
    @years = years
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_membership
    @current_membership = current_user.memberships.find_by_league_id(current_league)
  end

  def require_user_admin_privilege
    if !current_membership.admin
      render plain: "Unauthorized", status: :unauthorized
    end
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
