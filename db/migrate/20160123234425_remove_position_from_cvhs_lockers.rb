class RemovePositionFromCvhsLockers < ActiveRecord::Migration
  def change
  	remove_column :cvhs_lockers, :position, :string
  end
end
