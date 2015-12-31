require_relative 'Locker_Master'

class Client
	
	def initialize ()
	end
	@bob = (Locker_Master).new
		@lockers = ["2100","5300","7200","1100","1300"];
		@stu1 = ["Bob","Smith",123456];
		@stu2 = ["Jane","Doe",654321];
		@stu3 = ["Dark","Vader",696969]
	
		@bob.createLocker(@lockers,@stu3,@stu1);
		@bob.createSoloLocker(@lockers,@stu2);
end