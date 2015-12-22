class DeleteNumToCvhsLockers < ActiveRecord::Migration
  def change
  	delete_column :cvhs_lockers, :number, :int
  end
end
