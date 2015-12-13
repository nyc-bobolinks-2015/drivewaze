# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


startTime=DateTime.parse("12 Dec 2015 00:00:00")
360.times do
	TimeSlot.create(start_time:startTime)
	startTime=startTime+2.hours
end

sam = User.create!(email: "sam@example.com",
                password: "12345678",
                first_name: "Sam",
                last_name: "Purcell",
                phone: "818-307-6583",
                zipcode: '10005')

michael = User.create!(email: "michael@example.com",
	password: '12345678', first_name: "Micahel", last_name: "Landon", phone: "1234567890", zipcode: "10005")


listing = Listing.create!(street:"48 wall street", city: "New York", state: "NY", zipcode: "10005", parking_spot_type: 1, hourly_price: 5, daily_price: 30, weekly_price: 100, monthly_price: 375, compact_accepted: true, fullsize_accepted: true, oversized_accepted: true, space_description: "Driveway on a very busy street in a very busy neighborhood.", neighborhood_info: "The heart of the financial district! Right next to the NYSE.", public_transit_info: "Great public transit. Many different trains you can catch.", rules: "Be respectful of neighbors and quiet late at night.", instant_booking: true, user_id: sam.id)

Listing.create!(street:"222 East 80th St", city: "New York", state: "New York", zipcode: "10075", parking_spot_type: 1, hourly_price: 5, daily_price: 30, weekly_price: 100, monthly_price: 300, compact_accepted: true, fullsize_accepted: true, oversized_accepted: true, space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", instant_booking: false, user_id: sam.id)

Booking.create!(total:42,listing_id:listing.id,user_id:michael.id)
