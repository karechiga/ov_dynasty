class DropContracts < ActiveRecord::Migration[5.2]
  def change
    drop_table :contracts
  end
end
