class ChangeMinutesToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :players, :min_total, :decimal
  end
end
