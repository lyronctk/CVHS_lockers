class AddLockerNumToCvhsLockers < ActiveRecord::Migration
  def change
  	add_column :cvhs_lockers, :lockerNum, :integer
  end
end
