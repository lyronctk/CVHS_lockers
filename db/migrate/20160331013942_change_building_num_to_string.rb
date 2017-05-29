class ChangeBuildingNumToString < ActiveRecord::Migration
  def change
  	 change_column :unused_lockers, :building, :string
  end
end
