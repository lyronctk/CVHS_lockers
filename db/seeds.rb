if !Restriction.first
	Restriction.create!(grades: 9, floors:"", full_buildings:"")
end

counter = 9
while counter <= 29
	sum = 1100+counter
	(LockersDb.find_by locker_id: sum).delete
	counter++
end