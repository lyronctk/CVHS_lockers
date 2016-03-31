if !Restriction.first
	Restriction.create!(grades: 9, floors:"", full_buildings:"")
end