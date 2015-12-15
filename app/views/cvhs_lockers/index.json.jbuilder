json.array!(@cvhs_lockers) do |cvhs_locker|
  json.extract! cvhs_locker, :id, :name1, :name2, :studentID1, :studentID2, :number
  json.url cvhs_locker_url(cvhs_locker, format: :json)
end
