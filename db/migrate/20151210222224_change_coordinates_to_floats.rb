class ChangeCoordinatesToFloats < ActiveRecord::Migration
  def change
    rename_column :listings, :llongitude, :longitude
    change_column :listings, :longitude, :float
    change_column :listings, :latitude, :float
  end
end
