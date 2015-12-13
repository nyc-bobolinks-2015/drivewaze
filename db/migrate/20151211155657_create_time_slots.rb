class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
    	
    	t.datetime :start_time
    	t.text :year
    	t.text :month
    	t.text :day

      t.timestamps null: false
    end
  end
end
