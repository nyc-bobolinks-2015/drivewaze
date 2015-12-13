class CreateParkingSlotsTimeSlots < ActiveRecord::Migration
  def change
    create_table :parking_slots_time_slots do |t|
    	t.boolean :booked
    	t.boolean :unavailable

    	t.references :parking_slot
    	t.references :time_slot
      t.timestamps null: false
    end
  end
end
