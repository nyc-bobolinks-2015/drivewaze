class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.boolean :booked, default:false
      t.boolean :unavailable, default:false

    	t.datetime :start_time
      t.datetime :end_time

      t.references :parking_slot,null:false
      t.references :booking
      t.timestamps null: false
    end
  end
end
