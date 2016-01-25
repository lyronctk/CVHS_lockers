json.array!(@cvhs_lockers) do |cvhs_locker|
  json.extract! cvhs_locker, :name1, :name2, :studentID1, :studentID2, :pref1, :pref2, :pref3, :lastName1, :lastName2, :lockerNum, :buildingNum
  json.url cvhs_locker_url(cvhs_locker, format: :json)
end
