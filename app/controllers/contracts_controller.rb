class ContractsController < ApplicationController

  def create
    @player = Player.find(params[:player_id])
    @player.contract.create(contract_params)
  end



  private

  def contract_params
    params.require(:contract).permit(:salaries, :years, :team_options)
  end
end
