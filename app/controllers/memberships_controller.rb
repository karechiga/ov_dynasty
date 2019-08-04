class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_admin_privilege, only: :update

  def index
    @memberships = current_league.memberships
  end

  def create
    membership = current_user.memberships.create(league: current_league)
    roster = current_user.rosters.create(league: current_league)
    redirect_to league_homes_path(membership.league_id)
  end

  def update
    membership = Membership.find(params[:id])
    if !current_user.memberships.find_by_league_id(current_league).admin
      return render plain: 'Not Allowed', status: :forbidden
    end
    admin = !membership.admin
    membership.update(admin: admin)
    redirect_to league_memberships_path(membership.league)
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def current_membership
    if !current_user.is_a_member?(current_league)
      render plain: "Unauthorized", status: :unauthorized
    end
    @current_membership = current_user.memberships.find_by_league_id(current_league)
  end

  def require_user_admin_privilege
    if !current_membership.admin
      render plain: "Unauthorized", status: :unauthorized
    end
  end
end
