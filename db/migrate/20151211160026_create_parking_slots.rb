class CreateParkingSlots < ActiveRecord::Migration
  def change
    create_table :parking_slots do |t|
    	t.integer :vehicle_class
    	t.integer :slot_type
    

      t.integer :daily_price
      t.integer :weekly_price
      t.integer :monthly_price

      t.references :listing
      t.timestamps null: false
    end
  end
end
