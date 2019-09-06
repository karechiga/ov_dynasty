class ChangeDefaultValueForPlayerStats < ActiveRecord::Migration[5.2]
  def change
    change_column_default :players, :gp, 0
    change_column_default :players, :min_total, 0.0
    change_column_default :players, :pts_total, 0
    change_column_default :players, :reb_total, 0
    change_column_default :players, :ast_total, 0
    change_column_default :players, :stl_total, 0
    change_column_default :players, :blk_total, 0
    change_column_default :players, :to_total, 0
    change_column_default :players, :fgm3_total, 0
    change_column_default :players, :fgm_total, 0
    change_column_default :players, :fta_total, 0
    change_column_default :players, :ftm_total, 0
    change_column_default :players, :fga_total, 0
    change_column_default :players, :fga3_total, 0
  end
end
