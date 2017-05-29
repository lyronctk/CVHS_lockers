class RenameLockerDb < ActiveRecord::Migration
    def change
  	rename_table :lockers_db, :lockers_dbs
  end
end
