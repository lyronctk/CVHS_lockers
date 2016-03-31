class CreateUnusedLockers < ActiveRecord::Migration
  def change
    create_table :unused_lockers do |t|
      t.integer :building
      t.integer :unique
      t.integer :locker_id
      t.timestamps null: false
    end
  end
end
