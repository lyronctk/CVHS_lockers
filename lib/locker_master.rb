require 'rubyXL'
#PROPERTY OF ANDREW S. DERTLI AND LYRON CO TING KEH
#THE USE AND/OR REPRODUCTION OF 'LockerMaster' OR ANY SEGMENTS OF IT IS FORBIDDEN WITHOUT THE EXPRESSED WRITTEN CONSENT OF BOTH OF SAID OWNERS 
class LockerMaster
	def initialize (locs, persons)
		a = Time.new;
		@@mega_counter = 0;
		@@locker_database = locs;
		@@student_database = persons;
		the_threads = [];
		
		#parses existing excel workbooks for student identities
		the_threads << Thread.new {
			@@stu_book = RubyXL::Parser.parse("#{@@student_database}.xlsx");
			@stu_sheet = @@stu_book.worksheets[0];
		}
		#parses existing excel workbooks for locker avaliability
		the_threads << Thread.new {
			@@lbook = RubyXL::Parser.parse("#{@@locker_database}.xlsx");
			@@lsheet = @@lbook.worksheets[0];
		
		#creates sheet where student id and lockeruniq will be stored
			if(@@lbook["Student Assignments"].nil?)
				@@worksheet = @@lbook.add_worksheet("Student Assignments");
				@@worksheet.add_cell(0, 0, "ID #");
				@@worksheet.add_cell(0, 1, "Lockeruniq");
			else
				@@worksheet = @@lbook["Student Assignments"];
			end
		
		#creates each worksheet with the correct lockers inside it 
		#the boolean should be updated to reflect that if those sheets are missing make them but it currently does not pose a problem so I'll leave it
			if(@@lbook[2].nil?)
				@@lbook.add_worksheet('1100');
				@@lbook.add_worksheet('1300');
				@@lbook.add_worksheet('1300_SINGLES');
				@@lbook.add_worksheet('2100');
				@@lbook.add_worksheet('2200');
				@@lbook.add_worksheet('2300');
				@@lbook.add_worksheet('5200');
				@@lbook.add_worksheet('5300');
				@@lbook.add_worksheet('7100');
				@@lbook.add_worksheet('7200');
				@@lbook.add_worksheet('7300');
				
				length = findNextAvailableRow(@@lsheet);
				
				for rr in 0..(length-1)
					row = @@lsheet[rr];
					if(row[1].value == 1000)
						for oa in 1..3
							if(oa == 2)
								next;
							elsif(row[4].value == oa && ((row[0].value).to_i < 1004049) )
								roo = findNextAvailableRow(@@lbook["1#{oa}00"]);
								@@lbook["1#{oa}00"].add_cell(roo,0,"#{row[3].value}");
								@@lbook["1#{oa}00"].add_cell(roo,1,"#{row[0].value}");
							elsif(row[4].value == oa && ((row[0].value).to_i > 1004048) )
								poo = findNextAvailableRow(@@lbook["1300_SINGLES"]);
								@@lbook["1300_SINGLES"].add_cell(poo,0,"#{row[3].value}");
								@@lbook["1300_SINGLES"].add_cell(poo,1,"#{row[0].value}");
							end
						end
					elsif(row[1].value == 2000)
						for oo in 1..3
							if(row[4].value == oo)
								pss = findNextAvailableRow(@@lbook["2#{oo}00"]);
								@@lbook["2#{oo}00"].add_cell(pss,0,"#{row[3].value}");
								@@lbook["2#{oo}00"].add_cell(pss,1,"#{row[0].value}");
							end
						end
					elsif(row[1].value == 5000)
						for rt in 2..3
							if(row[4].value == rt)
								qw = findNextAvailableRow(@@lbook["5#{rt}00"]);
								@@lbook["5#{rt}00"].add_cell(qw,0,"#{row[3].value}"); 
								@@lbook["5#{rt}00"].add_cell(qw,1,"#{row[0].value}");
							end
						end
					elsif(row[1].value == 7000)
						for pp in 1..3
							if(row[4].value== pp)
								re = findNextAvailableRow(@@lbook["7#{pp}00"]);
								@@lbook["7#{pp}00"].add_cell(re,0,"#{row[3].value}");
								@@lbook["7#{pp}00"].add_cell(re,1,"#{row[0].value}");
							end
						end
					end
				end
				
				@@lbook.write("#{@@locker_database}.xlsx");
			end
		}
			the_threads.each { |thr| thr.join };
		b= Time.new;
		puts "#{b-a}";
	end
	
	#takes in array of locker buildings/floor ex)["1300","7200",ect], array of student1["FN","LN","ID#"], array of student2["FN","LN","ID#"] and tries to assign locker
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public 
	def createLocker (l, s1, s2)
		@locker=l;
		@student1=s1;
		@student2=s2;
		@rownum = findNextAvailableRow(@@worksheet);
		
		if(personCombo(@student1) and personCombo(@student2) and checkLockerAvailable(@locker,true)[0])	
	#if they pass the tests, it writes down Student ID then Lockeruniq next to it, each person has a separate row 
			@@worksheet.add_cell(@rownum, 0, "#{@student1[2]}");
			@@worksheet.add_cell(@rownum, 1, "#{checkLockerAvailable(@locker,false)[1][2]}");
			@@worksheet.add_cell(@rownum+1, 0, "#{@student2[2]}");
			@@worksheet.add_cell(@rownum+1, 1, "#{checkLockerAvailable(@locker,false)[1][2]}");
			
			@@lbook.write("#{@@locker_database}.xlsx");
	#returns that locker was made and returns an array of all the locker information 
			return true , checkLockerAvailable(@locker,false)[1];
		else
			if (reasonNotAllowed(s1,@locker) == reasonNotAllowed(s2,@locker))
				error_reason = "#{reasonNotAllowed(s1,@locker)}"
			elsif (reasonNotAllowed(s1,@locker)!= "" and reasonNotAllowed(s2,@locker)!= "")
				error_reason = ("#{reasonNotAllowed(s1,@locker)} and #{reasonNotAllowed(s2,@locker)}")
			else
				error_reason = ("#{reasonNotAllowed(s1,@locker)} #{reasonNotAllowed(s2,@locker)}")
			end
	#returns unsuccessfully and reason(s) why
			return false , error_reason;
		end

	end
	
	#this is an alternate method; 
	#takes in array locker floor buildings/floor ["#","#",ect], array of student1["FN","LN","ID#"]
	#this is currently only being used for "1300_SINGLES" Lockers
	#EVERY VALUE MUST BE ENTERED AS A STRING
	public
	def createSoloLocker (l, s1)
		@locker= l;
		@student1= s1;
		@rownum = findNextAvailableRow(@@worksheet);
		
		if(personCombo(@student1) and checkLockerAvailable(@locker,true)[0])
	#if they pass the tests, writes down Student ID then Lockeruniq next to it
			@@worksheet.add_cell(@rownum, 0, "#{@student1[2]}");
			@@worksheet.add_cell(@rownum, 1, "#{checkLockerAvailable(@locker,false)[1][2]}");
			
			@@lbook.write("#{@@locker_database}.xlsx");
	#returns that locker was made and returns an array of all the locker information 
			return true, checkLockerAvailable(@locker,false)[1];
		else
	#returns unsuccessfully and reason(s) why
			return false , reasonNotAllowed(s1,checkLockerAvailable(@locker,false));
		end
	end
	
	#checks if stu matches up to a person on database provided 
	#stu[] is  assumed to go ["First Name", "Last Name","ID #"] while @stusheet goes ["ID #","Last Name","First Name"]
	private
	def checkRealPerson (stu)
		length = findNextAvailableRow(@stu_sheet)-1;
		# puts "#{@stu_sheet} #{length}";
		for worth in 0..length 
			if(stu[2] == @stu_sheet[worth][0].value and ("#{stu[1]}".casecmp("#{@stu_sheet[worth][1].value}") == 0) and ("#{stu[0]}".casecmp("#{@stu_sheet[worth][2].value}") == 0))
				@grdlvl = @stu_sheet[worth][4];
				return true;
			end
		end
		return false;
	end
	
	#returns grade level if such person exists
	#stu[] is  assumed to go ["First Name", "Last Name","ID #"];
	public
	def getGradeLvl(stu)
		a = 0;
		if(checkRealPerson(stu))
			a = @grdlvl.value;
		end
	end
	
	#Finalizes the lockers by creating two workbooks, one that the School Administrators can look at and one specifically for ETIS
	#Also clears the database of all assigned lockers
	public 
	def clearAll()
		t= Time.new
	
		eTIS_book = RubyXL::Workbook.new;
		eTIS_sheet = @@lbook["Student Assignments"].dup();
		eTIS_book.worksheets[0] = eTIS_sheet; 
		eTIS_book.write("FINAL Locker Sheet #{t.year}-ETIS.xlsx");
		
		cleaR_book = RubyXL::Workbook.new;
		cleaR_sheet = @@lbook["Student Assignments"];
		cleaR_book.worksheets[0] = cleaR_sheet; 
		
		length = findNextAvailableRow(cleaR_sheet);
		
		cleaR_sheet[0][0].change_contents('iD #',cleaR_sheet[0][0].formula);
		cleaR_sheet[0][1].change_contents('Lockeruniq',cleaR_sheet[0][1].formula);
		cleaR_sheet.add_cell(0,2,"First Name");
		cleaR_sheet.add_cell(0,3,"Last Name");
		
		for rows in 1...length
			iD_num = cleaR_sheet[rows][0].value;
			location = findPerson(iD_num,@stu_sheet);
			if(location != -1)
				cleaR_sheet.add_cell(rows,2,"#{@stu_sheet[location][2].value}");
				cleaR_sheet.add_cell(rows,3,"#{@stu_sheet[location][1].value}");
			end
		end
		
		clean_book = RubyXL::Workbook.new;
		clean_sheet = @@lbook[0];
		clean_book.worksheets[0] = clean_sheet; 
				
		clean_sheet[0][0].change_contents("#{@@lbook["Sheet Providing LockerUniqs"][0][0].value}",clean_sheet[0][0].formula);
		clean_sheet[0][1].change_contents("#{@@lbook["Sheet Providing LockerUniqs"][0][1].value}",clean_sheet[0][1].formula);
		clean_sheet[0][2].change_contents("#{@@lbook["Sheet Providing LockerUniqs"][0][2].value}",clean_sheet[0][2].formula);
		clean_sheet[0][3].change_contents("#{@@lbook["Sheet Providing LockerUniqs"][0][3].value}",clean_sheet[0][3].formula);
		clean_sheet[0][4].change_contents("#{@@lbook["Sheet Providing LockerUniqs"][0][4].value}",clean_sheet[0][4].formula);
		
		for thing in 1...findNextAvailableRow(clean_sheet);
			clean_sheet[thing][2].change_contents("B",@@lbook[0][1][2].formula);
		end
		# File.delete("#{@@locker_database}.xlsx");
		clean_book.write("#{@@locker_database}.xlsx");
		cleaR_book.write("Final Locker Sheet #{t.year}-ADMIN.xlsx");
	end
	
	public
	def findPerson(id,c_sheet)
		length = findNextAvailableRow(c_sheet);
		if(id != nil)
			for distance in 1...length
				if(id.to_i == c_sheet[distance][0].value.to_i)
					return distance;
				end
			end
		end
		dd = -1 ;
	end
	
	#enter id num, checks if the person has been entered on spreadshhet
	private
	def personNotUsed(stu)
		length = findNextAvailableRow(@@worksheet) - 1;
		for place in 0..(length)
				if(@@worksheet[place][0] != nil and @@worksheet[place][0].value == stu[2])
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
	#takes in locker array checks database on avaliability
	private
	def checkLockerAvailable(lock,rewrite)
		for building_spot in 0..(lock.length-1)
			length = findNextAvailableRow(@@lbook["#{lock[building_spot]}"]);
			if(length != 0)
				ww =(Random.new).rand(0..(length-1));
				df = (@@lbook["#{lock[building_spot]}"])[ww][0].value;
				toos = (@@lbook["#{lock[building_spot]}"])[ww][1].value;
				if(rewrite)
					@@lbook["#{lock[building_spot]}"].delete_row(ww);
					@bob = df;
					@nii = toos
					if (length == 1)
						@safety_1 = [lock[building_spot], @bob, @nii];
					end
				end
				return true, [lock[building_spot], @bob, @nii] ;
			end
		end
		er = false, @safety_1;
	end
	
	#takes out an assigned locker based on lockeruniq and puts it back into the end of the spreadsheet it belongs to
	public
	def deleteLocker(student_ID)
		length = findNextAvailableRow(@@worksheet);
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
		
		length = findNextAvailableRow(@@lsheet);
		tempArray = ["","","",""];
		
		for row_number in 0...length
			if(@@lsheet[row_number][0].value == unique_ID)
				tempArray = [@@lsheet[row_number][0].value,@@lsheet[row_number][1].value,@@lsheet[row_number][3].value,@@lsheet[row_number][4].value];
				break;
			end
		end
		building_floor = ((tempArray[1].to_i + (tempArray[3].to_i)*100).to_s); 
		length = findNextAvailableRow(@@lbook["#{building_floor}"]);
		
		@@lbook["#{building_floor}"].add_cell(length,0,tempArray[2].to_s);
		@@lbook["#{building_floor}"].add_cell(length,1,tempArray[0].to_s);
		
		@@worksheet.delete_row(place_hold);
		@@worksheet.delete_row(place_hold);
		@@lbook.write("#{@@locker_database}.xlsx");
	end
	
	#returns which floors are avaliable and which aren't in two separate hashes,respectively
	public
	def getAvaliableFloors()
		hash_array = ["","","","","","","","","","",""]; 
		building_array = ["","","","","","","","","","",""]
		for sheet_tab in 2..12
			hash_array[sheet_tab-2] =  isEmpty(@@lbook[sheet_tab]);
		end
		
		avaliable_hash = Hash.new;
		empty_hash = Hash.new;
		for spot in 0..10
			a = @@lbook[spot+2].sheet_name;
			temp_hash = {"#{createSentence(a)}" => (a)}
			
			if(hash_array[spot] == false && !createSentence(a).nil?)
				avaliable_hash.merge!(temp_hash);
			elsif(hash_array[spot] == true && !createSentence(a).nil?)
				empty_hash.merge!(temp_hash);
			end
		end
		
		return avaliable_hash,empty_hash;
	end
	
	#input building/floor (ex. 1300,7100) and get if it is empty or not 
	private 
	def isEmpty(address)
		if(findNextAvailableRow(address) != 0)
			return false;
		end
		default = true;
	end
	
	private
	def createSentence(bldg)
		if(bldg.length >4)
			return nil;
		end
		
		thousands = (bldg.to_i/1000).to_i;
		hundreds = (bldg.to_i%1000)/100;
		floor = "";
		
		if(hundreds==1)
			floor = "First";
		elsif(hundreds==2)
			floor = "Second";
		elsif(hundreds==3)
			floor = "Third";
		end
			return "#{thousands}000 Building - #{floor} Floor";
	end
	
	#finds the length of the worksheet
	public
	def findNextAvailableRow(database)
		if(database.nil?)
			return 0;  
		elsif(database[@@mega_counter].nil?)
			rg = @@mega_counter;
			@@mega_counter = 0;
			return rg;
		else
			@@mega_counter = @@mega_counter + 1;
			findNextAvailableRow(database);
		end
	end
	#returns the reason why a locker cannot be created
	private
	def reasonNotAllowed(stu,lock)
		a="";
		if (!personNotUsed (stu))
			a= "#{stu[0]} #{stu[1]} already has a locker";
		elsif (!checkRealPerson (stu))
			a= "#{stu[0]} #{stu[1]} (#{stu[2]}) is not a student"
		elsif (!checkLockerAvailable(lock,false)[0])
			a= "There are no preferred lockers Available";
		else
			a= "";
		end
		return a;
	end
end