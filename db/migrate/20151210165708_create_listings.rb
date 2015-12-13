class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :street,null:false
      t.string :city, null:false
      t.string :state, null:false
      t.string :zipcode, null:false

      t.string :space_description
      t.string :neighborhood_info
      t.string :public_transit_info
      t.string :other_info
      t.string :rules

      t.boolean :instant_booking,null:false

      t.references :user, null:false
      t.timestamps null:false
    end
  end
end
