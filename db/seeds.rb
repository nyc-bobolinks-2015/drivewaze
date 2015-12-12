# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Listing.create!(street:"222 East 80th St", city: "New York", state: "New York", zipcode: "10075", parking_spot_type: 1, hourly_price: 5, daily_price: 30, weekly_price: 100, monthly_price: 300, compact_accepted: true, fullsize_accepted: true, oversized_accepted: true, space_description: "big space", neighborhood_info: "good", public_transit_info: "7 and 2 train close", other_info: "garage", rules: "close door when leaving", instant_booking: false, user_id: 2)
Booking.create!(total:42,listing_id:1,user_id:1)

