class CreateContractYears < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_years do |t|
      t.string :season
      t.decimal :salary
      t.boolean :team_option
      t.timestamps
    end
  end
end
