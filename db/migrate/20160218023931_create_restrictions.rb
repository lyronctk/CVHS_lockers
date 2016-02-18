class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.integer :floors
      t.integer :grades

      t.timestamps null: false
    end
  end
end
