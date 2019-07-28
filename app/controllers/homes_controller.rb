class HomesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_league
  def index
    @league = current_league
  end

  private

  def current_league
    @current_league ||= League.find(params[:league_id])
  end

  def require_authorized_for_league
    if !current_user.is_a_member?(current_league)
      render plain: "Unauthorized", status: :unauthorized
    end
  end
end
