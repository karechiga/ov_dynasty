class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|
      t.decimal :salaries, array: true
      t.integer :years
      t.boolean :team_options, array: true
      t.timestamps
    end
  end
end
