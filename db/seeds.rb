# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CvhsLocker.create!(name1: "Billy Joe",
             name2: "Barrack Obama",
             studentID1: "123456", 
             studentID2: "567890",
             pref1: 5100, 
             pref2: 5200, 
             pref3: 5300, 
             pref4: 5100,
             pref5: 5200)

100.times do |n|
  name1  = Faker::Name.name
  name2  = Faker::Name.name

  CvhsLocker.create!(name1: name1,
             name2: name2,
             studentID1: "123456", 
             studentID2: "567890",
             pref1: 5100, 
             pref2: 5200, 
             pref3: 5300, 
             pref4: 5100,
             pref5: 5200)
end