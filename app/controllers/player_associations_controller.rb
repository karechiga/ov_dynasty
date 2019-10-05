class PlayerAssociationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_membership
  before_action :require_user_roster_owner

  def destroy
    # subtract all remaining contract years from salary_total
    # move contract years down to salary_adds (cut in half or by whatever percentage desired)
    player_association = current_player_association
    player_association.contract_years.destroy_all
    # destroy player association
    player_association.destroy
    redirect_to league_roster_path(current_league, current_roster)
  end

  def update
    current_player_association.update_attributes(:roster_spot_id => params[:roster_spot_id])
    render plain: 'updated!'
  end 

  private
  
  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_roster
    @current_roster ||= Roster.find(params[:roster_id])
  end
  
  def current_player_association
    @current_player_association ||= PlayerAssociation.find(params[:id])
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
