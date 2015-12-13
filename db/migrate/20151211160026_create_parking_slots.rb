class CreateParkingSlots < ActiveRecord::Migration
  def change
    create_table :parking_slots do |t|
    	t.integer :vehicle_class
    	t.integer :slot_type
    	
    	t.integer :p1
    	t.integer :p2

      t.references :listing
      t.timestamps null: false
    end
  end
end
