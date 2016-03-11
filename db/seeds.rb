

# CvhsLocker.create!(name1: "Billy",
#              lastName1: "Joe",
#              name2: "Barrack",
#              lastName2: "Obama",
#              studentID1: "123456", 
#              studentID2: "567890",
#              pref1: 5100, 
#              pref2: 5200, 
#              pref3: 5300,
#              position: "Top")

# 100.times do |n|
#   name1  = Faker::Name.name
#   name2  = Faker::Name.name

#   pos1 = name1.index(' ') + 1
#   pos2 = name2.index(' ') + 1
  
#   lastName1 = name1[pos1..(name1.length-1)]
#   name1 = name1[0..(pos1-2)]

#   lastName2 = name2[pos2..(name2.length-1)]
#   name2 = name2[0..(pos1-2)]


#   CvhsLocker.create!(name1: name1,
#              lastName1: lastName1,
#              name2: name2,
#              lastName2: lastName2,
#              studentID1: "123456", 
#              studentID2: "567890",
#              pref1: 5100, 
#              pref2: 5200, 
#              pref3: 5300)
# end