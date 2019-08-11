class Admin::ContractYearsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_admin_privilege
  
  def create
    contract_year = current_player.contract_years.create(contract_year_params)
    redirect_to league_admin_roster_player(current_league, current_roster), method: :put
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_roster
    @current_roster ||= Roster.find(params[:roster_id])
  end

  def current_player
    @current_player ||= Roster.find(params[:player_id])
  end

  def current_membership
    @current_membership = current_user.memberships.find_by_league_id(current_league)
  end

  def require_user_admin_privilege
    if !current_membership.admin
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  def contract_year_params
    params.require(:contract_year).permit(:season, :salary, :team_option)
  end


end
