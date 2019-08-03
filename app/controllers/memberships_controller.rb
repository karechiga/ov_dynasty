class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    membership = current_user.memberships.create(league: current_league)
    roster = current_user.rosters.create(league: current_league)
    redirect_to league_homes_path(membership.league_id) 
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end
end
