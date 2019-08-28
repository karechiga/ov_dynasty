class Admin::PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_admin_privilege
  
  def index
    # @players = Player.where(:rosters => nil).paginate(:page => params[:page], per_page: 50).order('last_name ASC')
    # @players = Player.where.not( { associations: { roster_id: {league_id: current_league } } } )
    # @players.delete_if { |player| player.is_in_league?(current_league) }
    @players = Player.left_outer_joins(:leagues).where.not(leagues: { id: current_league })
    .or(Player.left_outer_joins(:leagues).where(leagues: { id: nil }))
    # .paginate(:page => params[:page], per_page: 50).order('last_name ASC')
    
    @roster = current_roster
    @league = current_league
    @contract_year = ContractYear.new

    respond_to do |format|
      format.html
      format.json { render json: PlayerDatatable.new(params) }
    end
  end

  def update
    # player = Player.find(params[:id]).update(roster_id: current_roster.id)
    player = Player.find(params[:id]).player_associations.create(roster_id: current_roster.id)
    redirect_to league_admin_roster_path(current_league, current_roster)
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_roster
    @current_roster ||= Roster.find(params[:roster_id])
  end

  def current_membership
    @current_membership = current_user.memberships.find_by_league_id(current_league)
  end

  def require_user_admin_privilege
    if !current_membership.admin
      render plain: "Unauthorized", status: :unauthorized
    end
  end

end
