class CreateAvailabilitySlots < ActiveRecord::Migration
  def change
    create_table :availability_slots do |t|
      t.references :booking,null:false
      t.references :listing,null:false

      t.datetime :start_date_time,null:false
      t.datetime :end_date_time,null:false

      t.timestamps null:false
    end
  end
end
