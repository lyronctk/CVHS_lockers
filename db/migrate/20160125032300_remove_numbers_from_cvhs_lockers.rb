class RemoveNumbersFromCvhsLockers < ActiveRecord::Migration
  def change
  	remove_column :cvhs_lockers, :number, :integer
  end
end
