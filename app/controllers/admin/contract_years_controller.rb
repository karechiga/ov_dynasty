class Admin::ContractYearsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_admin_privilege
  protect_from_forgery with: :null_session

  def create
    season = current_season
    roster_spot = current_roster.find_open_spot(current_player)
    if roster_spot == nil
      render plain: "No open spots left on roster", status: :unauthorized
    else
      player_association = current_player.player_associations.create(roster_spot_id: roster_spot.id)
      num_params.times do |i|
        contract_year = player_association.contract_years.create(contract_year_params["contract_years"][i]["contract_year"].merge(season: season))
        # if !contract_year.valid?
        #   return render plain: "#{contract_year_params["contract_years"][i]["contract_year"]}", status: :unprocessable_entity
        # end
        season += 1
      end
      redirect_to league_roster_path(current_league, current_roster)
    end
  end
  
  private
  
  def current_league
    @current_league ||= League.find(params[:league_id])
  end
  
  def current_roster
    @current_roster ||= Roster.find(params[:roster_id])
  end
  
  def current_player
    @current_player ||= Player.find(params[:player_id])
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
    params.require(:contract_years).permit({ 
      contract_years: [
        contract_year: [
          :salary,
          :team_option
        ] 
      ]
    })
    # params.require(:contract_year).permit(:season, :salary, :team_option)
  end
  
  def num_params
    return contract_year_params["contract_years"].length
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

end
