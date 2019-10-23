class RosterSpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_membership
  before_action :require_user_roster_owner

  def valid_player
    @current_roster_spot = current_roster_spot
    @player = player
    render json: @current_roster_spot.player_is_valid?(@player)
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_roster
    @current_roster ||= Roster.find(params[:roster_id])
  end

  def current_roster_spot
    @current_roster_spot ||= RosterSpot.find(params[:id])
  end
  
  def current_player_association
    @current_player_association = @current_roster_spot.player_association
  end

  def current_player
    @current_player = @current_player_association.player
  end

  def player_association
    @player_association ||= PlayerAssociation.find(params[:player_association_id])
  end

  def player
    @player = player_association.player
  end

  def current_membership
    @current_membership = current_user.memberships.find_by_league_id(current_league)
  end
  
  def require_user_membership
    if !current_user.is_a_member?(current_league)
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  def require_user_roster_owner
    if !current_user.owns_roster?(current_roster)
      render plain: "Unauthorized", status: :unauthorized
    end
  end
  
end
