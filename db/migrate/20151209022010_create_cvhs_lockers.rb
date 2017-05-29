class CreateCvhsLockers < ActiveRecord::Migration
  def change
    create_table :cvhs_lockers do |t|
      t.string :name1
      t.string :name2
      t.integer :studentID1
      t.integer :studentID2
      t.integer :number

      t.timestamps null: false
    end
  end
end
