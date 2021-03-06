class Admin::ToolsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_admin_privilege

  def index
    @league = current_league
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

end
