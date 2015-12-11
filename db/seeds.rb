# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create!(email: "sam@example.com",
                password_digest: "12345",
                first_name: "Sam",
                last_name: "Purcell",
                phone: "818-307-6583",
                zipcode: '10005')

