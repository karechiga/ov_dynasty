class CreateRosters < ActiveRecord::Migration[5.2]
  def change
    create_table :rosters do |t|
      t.string :team_name
      t.string :team_abbrev
      t.text :motto
      t.decimal :cap_space
      t.decimal :penalty
      t.decimal :traded_salary
      t.integer :wins
      t.integer :losses
      t.integer :ties
      t.integer :user_id
      t.timestamps
    end
    add_index :rosters, :user_id

  end
end
