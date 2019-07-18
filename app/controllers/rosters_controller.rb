class RostersController < ApplicationController

  def create
    @roster = current_user.rosters.create(roster_params)
  end

  private

  def roster_params
    params.require(:roster).permit(:team_name, :team_abbrev,
      :motto, :cap_space, :penalty, :traded_salary, :wins,
      :losses, :ties)
  end
end
