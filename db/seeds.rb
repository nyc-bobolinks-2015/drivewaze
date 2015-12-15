# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



sam = User.create!(email: "sam@example.com",
                password: "12345678",
                first_name: "Sam",
                last_name: "Purcell",
                phone: "818-307-6583",
                zipcode: '10005')

michael = User.create!(email: "michael.r.landon@gmail.com",
	password: '12345678', first_name: "Michael", last_name: "Landon", phone: "1234567890", zipcode: "10005")


listing = Listing.create!(address:"48 Wall Street, New York, NY 10005", space_description: "Driveway on a very busy street in a very busy neighborhood.", neighborhood_info: "The heart of the financial district! Right next to the NYSE.", public_transit_info: "Great public transit. Many different trains you can catch.", rules: "Be respectful of neighbors and quiet late at night.", user_id: sam.id)

listing2 = Listing.create!(address:"222 East 80th S, New York, NY 10005", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: sam.id)

listing3 = Listing.create!(address:"155 West 60th Street, New York, NY 10023", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: michael.id)

listing4 = Listing.create!(address:"1 World Trade Center, New York, NY 10023", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: sam.id)

listing5 = Listing.create!(address:"34 Middagh St, Brooklyn, NY 11201", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: sam.id)

listing5 = Listing.create!(address:"110 William St, New York, NY 10038", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: sam.id)

listing6 = Listing.create!(address:"101 Warren Street, New York, NY 10038", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: michael.id)

listing6 = Listing.create!(address:"194 Washington St, Jersey City, NJ 07302", space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", user_id: michael.id)

parking_slot1 = ParkingSlot.create!(vehicle_class: 1, slot_type: 1, daily_price: 20, weekly_price: 100, monthly_price: 300, listing_id: listing.id)
parking_slot2 = ParkingSlot.create!(vehicle_class: 1, slot_type: 1, daily_price: 20, weekly_price: 100, monthly_price: 300, listing_id: listing2.id)
parking_slot3 = ParkingSlot.create!(vehicle_class: 1, slot_type: 1, daily_price: 20, weekly_price: 100, monthly_price: 300, listing_id: listing3.id)

booking = Booking.create!(total: 320, listing_id: listing.id, user_id: michael.id)
