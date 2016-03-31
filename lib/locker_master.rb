require 'rubyXL'

class LockerMaster
	
	#Finalizes the lockers by creating two workbooks, one that the School Administrators can look at and one specifically for ETIS
	#Also clears the database of all assigned lockers
	public 
	def clearAll()
		t= Time.new

		dirname = ("complete_files")

		unless File.exists?("#{dirname}")
			Dir.mkdir("complete_files");
		end
		
		eTIS_book = RubyXL::Workbook.new;
		eTIS_sheet = @@lbook["Student Assignments"].dup();
		eTIS_book.worksheets[0] = eTIS_sheet; 
		eTIS_sheet[0][0].change_contents("#{@@lbook["Student Assignments"][0][0].value}",eTIS_sheet[0][0].formula)
		eTIS_sheet[0][1].change_contents("#{@@lbook["Student Assignments"][0][1].value}",eTIS_sheet[0][1].formula)
		eTIS_book.write("complete_files/FINAL Locker Sheet #{t.year}-ETIS.xlsx");
		
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
		cleaR_book.write("complete_files/Final Locker Sheet #{t.year}-ADMIN.xlsx");
	end

	public
	def writeToFile()
		@@lbook.write("#{@@locker_database}.xlsx");
	end
end