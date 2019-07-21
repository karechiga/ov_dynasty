class CreateLeagues < ActiveRecord::Migration[5.2]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :motto
      t.integer :num_teams
      t.timestamps
    end
  end
end
