class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.string :floors
      t.integer :grades

      t.timestamps null: false
    end
  end
end
