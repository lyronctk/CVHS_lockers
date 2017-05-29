class AddPrefToCvhsLockers < ActiveRecord::Migration
  def change
    add_column :cvhs_lockers, :pref1, :integer
    add_column :cvhs_lockers, :pref2, :integer
    add_column :cvhs_lockers, :pref3, :integer
    add_column :cvhs_lockers, :pref4, :integer
    add_column :cvhs_lockers, :pref5, :integer
  end
end
