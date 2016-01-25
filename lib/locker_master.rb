class LockerMaster
	def initialize (locs, persons)
		@locker_path = File.join(Rails.root, 'lib', 'Lockers.xlsx')

		@a= Time.new ;
		@jking = 0;
		#lockers lists 
		@@liist = locs;
		#student lists
		
		@@list = persons;
		@wbook = RubyXL::Parser.parse("#{@@list}.xlsx");
		@wsheet = @wbook.worksheets[0];
		ff = Time.new;
		@@lbook = RubyXL::Parser.parse("#{@@liist}.xlsx");
		@@lsheet = @@lbook.worksheets[0];
		gg = Time.new;	
		if (File.exists?(@locker_path))
			
			@@workbook = RubyXL::Parser.parse(@locker_path);
			@@worksheet = @@workbook.worksheets[0]
			@@workbook.write(@locker_path);
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
			
			@@workbook.write(@locker_path);
		end
			
		if(@@lbook[6].nil?)
			@@lbook.add_worksheet('1100');
			@@lbook.add_worksheet('1300');
			@@lbook.add_worksheet('2100');
			@@lbook.add_worksheet('2200');
			@@lbook.add_worksheet('2300');
			@@lbook.add_worksheet('5200');
			@@lbook.add_worksheet('5300');
			@@lbook.add_worksheet('7100');
			@@lbook.add_worksheet('7200');
			@@lbook.add_worksheet('7300');
			# loclist = [[lsheet11,lsheet13],[lsheet21,lsheet22,lsheet23],[lsheet52,lsheet53],[lsheet71,lsheet72,lsheet73]];
			
			length = findNextAvaliableRow(@@lsheet);
			
			for rr in 0..(length-1)
				row = @@lsheet[rr];
				if(row[1].value == 1000)
					for oa in 1..3
						if(oa == 2)
							next;
						elsif(row[4].value == oa)
							roo = findNextAvaliableRow(@@lbook["1#{oa}00"]);
							@@lbook["1#{oa}00"].add_cell(roo,0,"#{row[3].value}");
							@@lbook["1#{oa}00"].add_cell(roo,1,"#{row[0].value}");
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
			
			@@lbook.write("#{@@liist}.xlsx");
		end
		hh = Time.new;
		
		puts "#{ff-@a} \n#{gg-ff} \n#{hh-gg} \n#{hh-@a}";
	end
	
	#public takes in array locker, array of student1, array of student2 
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public 
	def createLocker (l, s1, s2)
		
		@locker=l;
		@student1=s1;
		@student2=s2;
		@rownum = findNextAvaliableRow(@@worksheet);
		
		if(personCombo(@student1) and personCombo(@student2) and checkLockerAvaliable(@locker,true)[0])
				for i in 0..6
					if(i<3)
						@@worksheet.add_cell(@rownum, i, "#{@student1[i]}");
					elsif(i<6)
						@@worksheet.add_cell(@rownum, i, "#{@student2[i-3]}");
					else
						@@worksheet.add_cell(@rownum, i, "#{checkLockerAvaliable(@locker,false)[1][1]}");
					end
				end
				@@lbook.write("#{@@liist}.xlsx");
				@@workbook.write(@locker_path);
				@b=Time.new ;
				puts "#{@b-@a}";
				return true , checkLockerAvaliable(@locker,false)[1];
		else
			error_reason = "#{reasonNotAllowed(s1,checkLockerAvaliable(@locker,false))} and #{reasonNotAllowed(s2,checkLockerAvaliable(@locker,false))}"
			return false , error_reason;
		end
		
	end

	
	#public  this is an alternate method; takes in array locker, array of student1
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public
	def createSoloLocker (l, s1)
		@locker=l;
		@student1=s1;
		@rownum = findNextAvaliableRow(@@worksheet);
		
		
		if(personCombo(@student1) and soloAllowed(@student1) and checkLockerAvaliable(@locker,true)[0])
			for i in 0..6
					if(i<3)
						@@worksheet.add_cell(@rownum, i, "#{@student1[i]}");
					elsif(i<6)
						;
					else
						@@worksheet.add_cell(@rownum, i, "#{checkLockerAvaliable(@locker,false)[1][1]}");
					end
				end	
				@@lbook.write("#{@@liist}.xlsx");
				@@workbook.write(@locker_path);
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
	public
	def checkRealPerson (stu)
		
		length = findNextAvaliableRow(@wsheet) - 1;
		tstu = ["ee","rr","tt"];
		temp = ["0","0","0","0"];
		
		#fixes stu to order of database
		for n in 0..2
			tstu[n] = stu[2-n];
		end
		stu = tstu;
		
		for worth in 0..length 
			for gg in  0..3
				if(gg==3)
					temp[gg]=@wsheet[worth][4].value;
				else
					temp[gg]= @wsheet[worth][gg].value;
				end
				
			end
			
			if(stu[0] == temp[0] and ("#{stu[1]}".casecmp("#{temp[1]}") == 0) and ("#{stu[2]}".casecmp("#{temp[2]}") == 0))
				return true;
			end
		end
		
		tpp= false;
	end
	
	#private enter id num, checks if the person has been entered on spreadshhet
	#fix it for solo
	def personNotUsed (stu)
		
		notUsed = true;
		rr = findNextAvaliableRow(@@worksheet) - 1;
		
		for xc in 0..(rr)
				if(@@worksheet[xc][2].value == stu[2])
					notUsed = false;
				elsif (!(@@worksheet[xc][5].nil?))
					if(@@worksheet[xc][5].value == stu[2] )
						notUsed = false;
					end
				end
		end
		return notUsed;
	end
	
	#test it
	def personCombo(stu)
		we = false;
		if(checkRealPerson(stu) and personNotUsed(stu))
			we = true;
		end
		
	end
	#private takes in locker array checks database on avaliability
	#nvm(also create/adds to list of used lockers)nvm instead deletes from list created from list 
	#$$change to locker num return$$
	public
	def checkLockerAvaliable(lock,thingy)
		
		# locklist =  Array.new(lock.length) { Array.new(2) }
		
		# for n in 0..(lock.length-1)
			# locklist[n] = [((((lock[n].to_i)/1000).to_i)),(((lock[n].to_i)%1000)/100).to_i];
			# puts "#{locklist[n]} ";
		# end
		
		# @@lbook.write("#{@@liist}.xlsx");
			 
		for as in 0..(lock.length-1)
			qq = findNextAvaliableRow((@@lbook["#{lock[as]}"]))
			if(qq != 0)
				ww =(Random.new).rand(0..(qq-1));
				df = (@@lbook["#{lock[as]}"])[ww][0].value;
				toos = (@@lbook["#{lock[as]}"])[ww][1].value;
				if(thingy)
					@@lbook["#{lock[as]}"].delete_row(ww);
					@bob = df;
					@nii = toos
				end
				return true, [lock[as], @bob, @nii] ;
			end
		end
		
		er = false;
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
	#test this
	#use recursion-->problems with recursion
	def findNextAvaliableRow(database)
		y=0;
		while (database[y][0].value != nil)
			y=y+1;
		end
		rescue Exception
			return y;
		# if(!database[@jking][0].nil?)
			# @jking= @jking+1;
			# findNextAvaliableRow(database);
		# else
			# rg = @jking;
			# @jking = 0;
			# return rg;
		# end
	end
	#got it done#fix here checkLockerAvaliable is called a second time
	def reasonNotAllowed (stu,lock)
		a="";
	
		if (!personNotUsed (stu))
			a= "#{stu[0]} #{stu[1]} already has a locker";
		elsif (!checkRealPerson (stu))
			a= "#{stu[0]} #{stu[1]} is not a student"
		elsif (!checkLockerAvaliable(lock,false)[0])
			a= "There are no preferred lockers avaliable";
		else
			a= "Something's wrong with the other person";
		end
		
		return a;
	end
end