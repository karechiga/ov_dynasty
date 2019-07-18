class PicksController < ApplicationController

  def create
    @roster = Roster.find(params[:roster_id])
    @roster.pick.create(contract_params)
  end



  private

  def contract_params
    params.require(:pick).permit(:name, :year, :round, :comment)
  end
end
