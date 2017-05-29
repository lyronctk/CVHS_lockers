class RenameUnusedLockers < ActiveRecord::Migration
  def change
  	rename_table :unused_lockers, :lockers_db
  end
end
