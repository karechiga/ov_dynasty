class AddRosterIdToPicks < ActiveRecord::Migration[5.2]
  def change
    add_column :picks, :roster_id, :integer
  end
end
