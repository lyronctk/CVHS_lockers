if !Restriction.first
	Restriction.create!(grades: 9, floors:"", full_buildings:"")
end

person = CvhsLocker.find_by(lastName2: "Sinany")
person.studentID2 = 311361
person.save