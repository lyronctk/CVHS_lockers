class LockerApprentice

	def initialize (locs)
		@@locker_apprentice = locs;
		@@recursion_var = 0;
		@@App_book = RubyXL::Parser.parse("#{@@locker_apprentice}.xlsx");
	end
	
	public
	def isEmpty(address)
		if(findNextAvaliableRow(address) != 0)
			return false;
		end
		default = true;
	end
	
	public
	def getFilledFloors()
		temp_array = Array.new(11);
		a = 0
		for sheet_tab in 2..12
			if(isEmpty(@@App_book[sheet_tab]) and @@App_book[sheet_tab].sheet_name != "1300_SINGLES")
				temp_array[sheet_tab-2] = @@App_book[sheet_tab].sheet_name;
				a= a + 1;
				puts "#{temp_array[sheet_tab-2]} #{a}"
			end
		end
		
		temp_array.delete(nil);
		
		return temp_array;
	end
	
	private
	def findNextAvaliableRow(database)
		if(database.nil?)
			return 0;
		elsif(database[@@recursion_var].nil?)
			rg = @@recursion_var;
			@@recursion_var = 0;
			return rg;
		else
			@@recursion_var = @@recursion_var + 1;
			findNextAvaliableRow(database);
		end
	end
end