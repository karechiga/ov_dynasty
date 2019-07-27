class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.memberships.create(league: current_league)
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end
end
