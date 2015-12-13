class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :address, null: false

      t.string :space_description
      t.string :neighborhood_info
      t.string :public_transit_info
      t.string :other_info
      t.string :rules

      t.references :user, null:false
      t.timestamps null:false
    end
  end
end
