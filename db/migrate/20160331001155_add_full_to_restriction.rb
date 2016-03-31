class AddFullToRestriction < ActiveRecord::Migration
  def change
  	add_column :restrictions, :full_buildings, :string
  	add_column :cvhs_lockers, :locker_unique, :string
  end
end
