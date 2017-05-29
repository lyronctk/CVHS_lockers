class AddBuildingToCvhsLockers < ActiveRecord::Migration
  def change
  	add_column :cvhs_lockers, :buildingNum, :string
  end
end
