class AddLatAndLongToListings < ActiveRecord::Migration
  def change
    add_column :listings, :latitude, :decimal
    add_column :listings, :llongitude, :decimal
  end
end
