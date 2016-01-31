 class LockerMaster
	def initialize (locs, persons)
			@a= Time.new ;
		@jking = 0;
		@@locker_database = locs;
		@@student_database = persons;
		
		@stu_book = RubyXL::Parser.parse("#{@@student_database}.xlsx");
		@stu_sheet = @stu_book.worksheets[0];
			ff = Time.new;
		@@lbook = RubyXL::Parser.parse("#{@@locker_database}.xlsx");
		@@lsheet = @@lbook.worksheets[0];
			gg = Time.new;	
		
		if(@@lbook["Student Assignments"].nil?)
			@@worksheet = @@lbook.add_worksheet("Student Assignments");
			@@worksheet.add_cell(0, 0, "ID #");
			@@worksheet.add_cell(0, 1, "Lockeruniq");
		else
			@@worksheet = @@lbook["Student Assignments"];
		end
		
		if(@@lbook[6].nil?)
			@@lbook.add_worksheet('1100');
			@@lbook.add_worksheet('1300');
			@@lbook.add_worksheet('TRIPLES');
			@@lbook.add_worksheet('2100');
			@@lbook.add_worksheet('2200');
			@@lbook.add_worksheet('2300');
			@@lbook.add_worksheet('5200');
			@@lbook.add_worksheet('5300');
			@@lbook.add_worksheet('7100');
			@@lbook.add_worksheet('7200');
			@@lbook.add_worksheet('7300');
			
			length = findNextAvaliableRow(@@lsheet);
			
			for rr in 0..(length-1)
				row = @@lsheet[rr];
				if(row[1].value == 1000)
					for oa in 1..3
						if(oa == 2)
							next;
						elsif(row[4].value == oa && ((row[0].value).to_i < 1004049) )
							roo = findNextAvaliableRow(@@lbook["1#{oa}00"]);
							@@lbook["1#{oa}00"].add_cell(roo,0,"#{row[3].value}");
							@@lbook["1#{oa}00"].add_cell(roo,1,"#{row[0].value}");
						elsif(row[4].value == oa && ((row[0].value).to_i > 1004048) )
							poo = findNextAvaliableRow(@@lbook["TRIPLES"]);
							@@lbook["TRIPLES"].add_cell(poo,0,"#{row[3].value}");
							@@lbook["TRIPLES"].add_cell(poo,1,"#{row[0].value}");
						end
					end
				elsif(row[1].value == 2000)
					for oo in 1..3
						if(row[4].value == oo)
							pss = findNextAvaliableRow(@@lbook["2#{oo}00"]);
							@@lbook["2#{oo}00"].add_cell(pss,0,"#{row[3].value}");
							@@lbook["2#{oo}00"].add_cell(pss,1,"#{row[0].value}");
						end
					end
				elsif(row[1].value == 5000)
					for rt in 2..3
						if(row[4].value == rt)
							qw = findNextAvaliableRow(@@lbook["5#{rt}00"]);
							@@lbook["5#{rt}00"].add_cell(qw,0,"#{row[3].value}"); 
							@@lbook["5#{rt}00"].add_cell(qw,1,"#{row[0].value}");
						end
					end
				elsif(row[1].value == 7000)
					for pp in 1..3
						if(row[4].value== pp)
							re = findNextAvaliableRow(@@lbook["7#{pp}00"]);
							@@lbook["7#{pp}00"].add_cell(re,0,"#{row[3].value}");
							@@lbook["7#{pp}00"].add_cell(re,1,"#{row[0].value}");
						end
					end
				else 
					puts "something is happenin  I don't know what  #{rr} ";
				end
			end
			
			@@lbook.write("#{@@locker_database}.xlsx");
		end
		
			hh = Time.new;
			puts "#{ff-@a}\n#{gg-ff}\n#{hh-gg}\n#{hh-@a}";
	end
	
	#public takes in array locker, array of student1, array of student2 
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public 
	def createLocker (l, s1, s2)
		
		@locker=l;
		@student1=s1;
		@student2=s2;
		@rownum = findNextAvaliableRow(@@worksheet);
		
		#put to new list CVHS LOCKER TEMPLATE
		if(personCombo(@student1) and personCombo(@student2) and checkLockerAvaliable(@locker,true)[0])	
			@@worksheet.add_cell(@rownum, 0, "#{@student1[2]}");
			@@worksheet.add_cell(@rownum, 1, "#{checkLockerAvaliable(@locker,false)[1][2]}");
			@@worksheet.add_cell(@rownum+1, 0, "#{@student2[2]}");
			@@worksheet.add_cell(@rownum+1, 1, "#{checkLockerAvaliable(@locker,false)[1][2]}");
			
			@@lbook.write("#{@@locker_database}.xlsx");
			
			@b=Time.new ;
			puts "#{@b-@a}";
			return true , checkLockerAvaliable(@locker,false)[1];
		else
			error_reason = ("#{reasonNotAllowed(s1,checkLockerAvaliable(@locker,false))} and\n#{reasonNotAllowed(s2,checkLockerAvaliable(@locker,false));}");
			return false , error_reason;
		end

	end
	#public  this is an alternate method; takes in array locker, array of student1
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public
	def createSoloLocker (l, s1)
		@locker= l;
		@student1= s1;
		@rownum = findNextAvaliableRow(@@worksheet);
		
		
		if(personCombo(@student1) and soloAllowed(@student1) and checkLockerAvaliable(@locker,true)[0])
			@@worksheet.add_cell(@rownum, 0, "#{@student1[2]}");
			@@worksheet.add_cell(@rownum, 1, "#{checkLockerAvaliable(@locker,false)[1][2]}");
			
			@@lbook.write("#{@@locker_database}.xlsx");
			@b=Time.new ;
			puts "#{@b-@a}";
			return true, checkLockerAvaliable(@locker,false)[1];
		else
			bbb = reasonNotAllowed(s1,checkLockerAvaliable(@locker,false));
			if(!soloAllowed(s1))
				aaa = "#{s1[0]} #{s1[1]} cannot have a locker by themself"
				return false, aaa;
			end
			return false , bbb;
		end
	end
	#private checks if name matches up to id on database provided 
	#goes id , last, first
	private
	#put list a class variable
	def checkRealPerson (stu)
		
		length = findNextAvaliableRow(@stu_sheet) - 1;
		tempstu = ["","",""];
		temp = ["0","0","0","0"];
		
		#fixes stu to order of database
		for n in 0..2
			tempstu[n] = stu[2-n];
		end
		stu = tempstu;
		
		for worth in 0..length 
			for gg in  0..2
					temp[gg]= @stu_sheet[worth][gg].value;
			end
			
			if(stu[0] == temp[0] && ("#{stu[1]}".casecmp("#{temp[1]}") == 0) && ("#{stu[2]}".casecmp("#{temp[2]}") == 0))
				@grdlvl = @stu_sheet[worth][4];
				return true;
			end
		end
		
		tpp= false;
	end
	
	public
	def getGradeLvl(stu)
		if(checkRealPerson(stu))
			return	@grdlvl;
		end
	end
	
	#private enter id num, checks if the person has been entered on spreadshhet
	#fix it for solo
	private
	def personNotUsed(stu)

		rr = findNextAvaliableRow(@@worksheet) - 1;
		
		for xc in 0..(rr)
				if(@@worksheet[xc][0].value == stu[2])
					return false;
				end
		end
		return true;
	end
	
	private
	def personCombo(stu)
		we = false;
		if(checkRealPerson(stu) and personNotUsed(stu))
			we = true;
		end
		
	end
	#private takes in locker array checks database on avaliability
	#nvm(also create/adds to list of used lockers)nvm instead deletes from list created from list 
	#$$change to locker num return$$
	private
	def checkLockerAvaliable(lock,rewrite)
		for as in 0..(lock.length-1)
			qq = findNextAvaliableRow((@@lbook["#{lock[as]}"]))
			if(qq != 0)
				ww =(Random.new).rand(0..(qq-1));
				df = (@@lbook["#{lock[as]}"])[ww][0].value;
				toos = (@@lbook["#{lock[as]}"])[ww][1].value;
				if(rewrite)
					@@lbook["#{lock[as]}"].delete_row(ww);
					@bob = df;
					@nii = toos
				end
				return true, [lock[as], @bob, @nii] ;
			end
		end
		
		er = [false];
	end
	public
	def deleteLocker(student_ID)
		length = findNextAvaliableRow(@@worksheet);
		unique_ID = -1;
		place_hold = -1;
		
		for row_num in 0...length
			if(student_ID.to_i == @@worksheet[row_num][0].value.to_i)
				unique_ID = @@worksheet[row_num][1].value.to_i;
				break;
			end
		end
		
		for row_num in 0...length
			if(unique_ID.to_i == @@worksheet[row_num][1].value.to_i)
				place_hold = row_num;
				break;
			end
		end
		
		length = findNextAvaliableRow(@@lsheet);
		tempArray = ["","","",""];
		
		for row_number in 0...length
			if(@@lsheet[row_number][0].value == unique_ID)
				tempArray = [@@lsheet[row_number][0].value,@@lsheet[row_number][1].value,@@lsheet[row_number][3].value,@@lsheet[row_number][4].value];
				break;
			end
		end
		building_floor = ((tempArray[1].to_i + (tempArray[3].to_i)*100).to_s); 
		length = findNextAvaliableRow(@@lbook["#{building_floor}"]);
		
		@@lbook["#{building_floor}"].add_cell(length,0,tempArray[2].to_s);
		@@lbook["#{building_floor}"].add_cell(length,1,tempArray[0].to_s);
		
		@@worksheet.delete_row(place_hold);
		@@worksheet.delete_row(place_hold);
		@@lbook.write("#{@@locker_database}.xlsx");
	end
	#########put in accessor for if sheet is empty#########
	
	# the special exception list of people get alternate locker constructor
	private
	def soloAllowed (stu)
		
		#### #   # ##### #### ####      ## #### ##    ####
		#    ##  #   #   #    #  #     #   #  # #  #  #
		###  # # #   #   ###  ####    #    #  # #   # ###
		#    #  ##   #   #    ##       #   #  # #  #  #
		#### #   #   #   #### # ##      ## #### ##    ####
		
		op = true;
	end
	#combine by adding parameter
	#use recursion-->problems with recursion
	def findNextAvaliableRow(database)
		y=0;
		until (database[y][0].value == nil)
			y=y+1;
		end
		rescue Exception
			return y;
		# @information = database;
		# if(@information[@jking][0].nil?)
			# rg = @jking;
			# @jking = 0;
			# return rg;
		# else
			# @jking = @jking + 1;
			# findNextAvaliableRow(information);
		# end
	end
	#got it done#fix here checkLockerAvaliable is called a second time #fixed the new error
	def reasonNotAllowed (stu,lock)
		a="";
	
		if (!personNotUsed (stu))
			a= "#{stu[0]} #{stu[1]} already has a locker";
		elsif (!checkRealPerson (stu))
			a= "#{stu[0]} #{stu[1]} is not a student"
		elsif (checkLockerAvaliable(lock,false)[0])
			a= "There are no preferred lockers avaliable";
		else
			a= "";
		end
		
		return a;
	end
end