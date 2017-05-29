class AddLastNameToCvhsLockers < ActiveRecord::Migration
  def change
  	add_column :cvhs_lockers, :lastName1, :string
  	add_column :cvhs_lockers, :lastName2, :string
  	add_column :cvhs_lockers, :position, :string
  	remove_column :cvhs_lockers, :pref4, :integer
  	remove_column :cvhs_lockers, :pref5, :integer
  end
end
