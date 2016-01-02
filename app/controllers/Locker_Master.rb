require 'rubyXL'
class Locker_Master
		begin
		if (File.exists?('Lockers.xlsx'))
			@@workbook = RubyXL::Parser.parse("Lockers.xlsx");
			@@worksheet = @@workbook.worksheets[0]
			
			@@workbook.write("Lockers.xlsx");
			
		else
			@@workbook = RubyXL::Workbook.new;
			@@worksheet = @@workbook.worksheets[0]
			@@worksheet.sheet_name = 'Lockers'
			
			@@worksheet.add_cell(0, 0, '#1 First Name');
			@@worksheet.add_cell(0, 1, '#1 Last Name');
			@@worksheet.add_cell(0, 2, '#1 ID');
			@@worksheet.add_cell(0, 3, '#2 First Name');
			@@worksheet.add_cell(0, 4, '#2 Last Name');
			@@worksheet.add_cell(0, 5, '#2 ID');
			@@worksheet.add_cell(0, 6, 'Locker#');
			
			@@workbook.write("Lockers.xlsx");
			
		end
	end
	
	def initialize ()
		if (File.exists?('Lockers.xlsx'))
			@@workbook = RubyXL::Parser.parse("Lockers.xlsx");
			@@worksheet = @@workbook.worksheets[0]
			
			@@workbook.write("Lockers.xlsx");
			
		else
			@@workbook = RubyXL::Workbook.new;
			@@worksheet = @@workbook.worksheets[0]
			@@worksheet.sheet_name = 'Lockers'
			
			@@worksheet.add_cell(0, 0, '#1 First Name');
			@@worksheet.add_cell(0, 1, '#1 Last Name');
			@@worksheet.add_cell(0, 2, '#1 ID');
			@@worksheet.add_cell(0, 3, '#2 First Name');
			@@worksheet.add_cell(0, 4, '#2 Last Name');
			@@worksheet.add_cell(0, 5, '#2 ID');
			@@worksheet.add_cell(0, 6, 'Locker#');
			
			@@workbook.write("Lockers.xlsx");
			
		end
	end
	
	#public takes in array locker, array of student1, array of student2 
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public 
	def createLocker (l, s1, s2)
		@locker=l;
		@student1=s1;
		@student2=s2;
		@rownum = findNextAvaliableRow();
		
		if(personCombo(@student1) and personCombo(@student2) and checkLockerAvaliable(@locker))
			for i in 0..6
				if(i<3)
					@@worksheet.add_cell(@rownum, i, "#{@student1[i]}");
				elsif(i<6)
					@@worksheet.add_cell(@rownum, i, "#{@student2[i-3]}");
				else
					@@worksheet.add_cell(@rownum, i, "#{checkLockerAvaliable(@locker)}");
				end
			end
			@@workbook.write("Lockers.xlsx");	
			return true;
		else
			reasonNotAllowed(s1);
			reasonNotAllowed(s2);
			return false
		end
	end

	
	#public  this is an alternate method; takes in array locker, array of student1
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public
	def createSoloLocker (l, s1)
		@locker=l;
		@student1=s1;
		@rownum = findNextAvaliableRow();
		if(personCombo(@student1) and soloAllowed(@student1) and checkLockerAvaliable(@locker))
		for i in 0..6
				if(i<3)
						@@worksheet.add_cell(@rownum, i, "#{@student1[i]}");
				elsif(i<6)
					;
				else
					@@worksheet.add_cell(@rownum, i, "#{checkLockerAvaliable(@locker)}");
				end
			end	
			@@workbook.write("Lockers.xlsx");
			return true;
		else
			reasonNotAllowed(s1);
			if(!soloAllowed)
				puts "#{s1[0]} #{s1[1]} cannot have a locker by themself";
			end
			return false;
		end
	end
	#private checks if name matches up to id on database provided
	private
	def checkRealPerson (stu)
			#workbook22 = RubyXL::Parser.parse("");
			#worksheet22 = workbook2.worksheets[0]
			
		#### #   # ##### #### ####      ## #### ##    ####
		#    ##  #   #   #    #  #     #   #  # #  #  #
		###  # # #   #   ###  ####    #    #  # #   # ###
		#    #  ##   #   #    ##       #   #  # #  #  #
		#### #   #   #   #### # ##      ## #### ##    ####
	
		return true;
	end
	
	#private enter id num, checks if the person has been entered on spreadsheet
	def personNotUsed (stu)
		
		notUsed = true;
		rr = findNextAvaliableRow() - 1;
		
		for xc in 0..(rr)
			if(@@worksheet[xc][2].value == stu[2])
				notUsed = false;
			elsif (@@worksheet[xc][5].value == stu[2])
				notUsed = false;
			else
				;
			end
		end
		return notUsed;
	end
	
	def personCombo(stu)
		if(checkRealPerson(stu) and personNotUsed(stu))
			return true;
		else
			return false;
		end
		
	end
	#private takes in locker array checks database on avaliability
	#also create/adds to list of used lockers
	#$$change to locker num return$$
	def checkLockerAvaliable (lock)
		x=0;
		
		#### #   # ##### #### ####      ## #### ##    ####
		#    ##  #   #   #    #  #     #   #  # #  #  #
		###  # # #   #   ###  ####    #    #  # #   # ###
		#    #  ##   #   #    ##       #   #  # #  #  #
		#### #   #   #   #### # ##      ## #### ##    ####
		
		if(true)
			return lock[x];
		else
			return false;
		end
	end
	
	# the special exception list of people get alternate locker constructor
	def soloAllowed (stu)
		
		#### #   # ##### #### ####      ## #### ##    ####
		#    ##  #   #   #    #  #     #   #  # #  #  #
		###  # # #   #   ###  ####    #    #  # #   # ###
		#    #  ##   #   #    ##       #   #  # #  #  #
		#### #   #   #   #### # ##      ## #### ##    ####
		
		return true;
	end
	
	def findNextAvaliableRow()
		y=0;
		while (@@worksheet.sheet_data[y][0].value != nil)
			y=y+1;
		end
		rescue Exception
			return y;
	end
	
	def reasonNotAllowed (stu)
		if (!personNotUsed (stu))
			puts "#{stu[0]} #{stu[1]} already has a locker";
		elsif (!checkRealPerson (stu))
			puts "#{stu[0]} #{stu[1]} is not a student"
		elsif (!checkLockerAvaliable (lock))
			puts "There are no preferred lockers avaliable";
		else
			puts "Something's wrong";
		end
	end
end