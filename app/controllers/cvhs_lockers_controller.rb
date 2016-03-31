class CvhsLockersController < ApplicationController
  before_action :set_cvhs_locker, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: :index

  # GET /cvhs_lockers
  # GET /cvhs_lockers.json
  def index
      # @cvhs_lockers = CvhsLocker.paginate(page: params[:page])
      @cvhs_lockers = CvhsLocker.all
  end

  # GET /cvhs_lockers/1 
  # GET /cvhs_lockers/1.json
  def success
  end

  # GET /cvhs_lockers/new
  def new
    @cvhs_locker = CvhsLocker.new
    floors = Restriction.first.full_buildings.split(" ") if Restriction.first
    session[:filled_floors] = floors
  end

  def admin_login
    if(params[:username] == ENV["USERNAME"] && params[:password] == ENV["PASSWORD"])
      session[:admin] = true;
      redirect_to "/index"
    end
  end

  def disclaimer
  end

  # GET /cvhs_lockers/1/edit
  def edit
  end

  # SWITCH OUT STUDENT LOCATOR
  def upload_students
    uploaded_io = params[:student_locator]

    File.open(Rails.root.join('lib', 'student_locator.xlsx'), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    Student.delete_all

    # seed lockers
    workbook = RubyXL::Parser.parse(Rails.root.join('lib', 'student_locator.xlsx'))
    worksheet = workbook[0]
    worksheet.delete_row(0)
    worksheet.each { |row|
      Student.create!(student_id: row[0].value, last_name: row[1].value, first_name: row[2].value, grade: row[4].value)
    }

    redirect_to '/index', :notice => "Student Locator successfully replaced"
  end

  def upload_lockers
    uploaded_io = params[:locker_guide]

    File.open(Rails.root.join('lib', 'CVHS Locker Template and Guide.xlsx'), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    LockersDb.delete_all
    CvhsLocker.delete_all

    # seed lockers
    workbook = RubyXL::Parser.parse(File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide.xlsx'))
    worksheet = workbook[0]
    worksheet.delete_row(0)
    worksheet.each { |row|
       if row[1].value == 1000 && (row[0].value).to_i > 1004048
          puts "Unique: #{row[0].value}, Building: 1300_SINGLES, Locker_id: #{row[3].value}"
          LockersDb.create!(building: "1300_SINGLES", unique: row[0].value, locker_id: row[3].value)
       else
          LockersDb.create!(building: "#{row[1].value+(row[4].value*100)}", unique: row[0].value, locker_id: row[3].value)
       end
    }

    redirect_to '/index', :notice => "Locker Guide successfully replaced"
  end

  # POST /cvhs_lockers
  # POST /cvhs_lockers.json
  def create
    @cvhs_locker = CvhsLocker.new(cvhs_locker_params)

    # grade restriciton
    if Restriction.first
      grade_restriction = Restriction.first[:grades]
    else
      grade_restriction = 0
    end

    # verify student
    person1 = checkValidPerson(cvhs_locker_params[:name1], cvhs_locker_params[:lastName1], cvhs_locker_params[:studentID1])
    person2 = checkValidPerson(cvhs_locker_params[:name2], cvhs_locker_params[:lastName2], cvhs_locker_params[:studentID2]) if @cvhs_locker[:name2]  != "" 
    if(!person1[0])
      redirect_to '/new', notice: person1[1] and return
    end
    if(person2 && !person2[0])
      redirect_to '/new', notice: person2 [1] and return
    end

    if grade_restriction && (person1[1].to_i >= grade_restriction || person2[1].to_i >= grade_restriction)
      if @cvhs_locker[:name2]  == "" 
        number = getLockerNum("1300_SINGLES")
        @cvhs_locker[:lockerNum] = number[0]
        @cvhs_locker[:locker_unique] = number[1]
        @cvhs_locker[:buildingNum] = "1300-Singles"
      else
        building = getAvailableBuilding(cvhs_locker_params[:pref1], cvhs_locker_params[:pref2], cvhs_locker_params[:pref3])
        number = getLockerNum(building)
        @cvhs_locker[:lockerNum] = number[0]
        @cvhs_locker[:locker_unique] = number[1]
        @cvhs_locker[:buildingNum] = building
      end
    else
      respond_to do |format|
        format.html { redirect_to '/new', notice: "Your grade level is not permitted to register yet." }
        format.json { render json: @cvhs_locker.errors, status: :unprocessable_entity }
      end
    end

    
    respond_to do |format|
      if @cvhs_locker.save
        # PASS IN RECEPIT INFORMATION
        session[:name1] = cvhs_locker_params[:name1]
        session[:lastName1] = cvhs_locker_params[:lastName1]
        session[:name2] = cvhs_locker_params[:name2]
        session[:lastName2] = cvhs_locker_params[:lastName2]
        session[:lockerNum] =  @cvhs_locker[:lockerNum]
        session[:buildingNum] = @cvhs_locker
        redirect_to '/success' and return;
        format.json { render :new, status: :created, location: @cvhs_locker }
      end
    end
  end

  # DELETE /cvhs_lockers/1
  # DELETE /cvhs_lockers/1.json
  def destroy
    LockersDb.create!(building: @cvhs_locker[:buildingNum], unique: @cvhs_locker[:locker_unique], locker_id: @cvhs_locker[:lockerNum])
    @cvhs_locker.destroy
    respond_to do |format|
      format.html { redirect_to cvhs_lockers_url, notice: 'Locker was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # DOWNLOAD FILE FOR ETIS
  def download
    send_file File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide.xlsx')
  end

  # RESET DATABASE
  def clear_all

    if(session[:cleared] == true) 
      redirect_to :back
    end

    t= Time.new
    master = (LockerMaster).new(File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide'), File.join(Rails.root, 'lib', 'student_locator'))
    
    master.clearAll()
    CvhsLocker.delete_all
    compress(File.join(Rails.root, "complete_files"))

    # RE-INITIALIZES TABS
    master = (LockerMaster).new(File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide'), File.join(Rails.root, 'lib', 'student_locator'))

    session[:cleared] = true;
    send_file File.join(Rails.root, "complete_files" , "complete_files.zip")
  end

  private
    # Use callbacks to  share common setup or constraints between actions.
    def set_cvhs_locker
      @cvhs_locker = CvhsLocker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cvhs_locker_params
      params.require(:cvhs_locker).permit(:name1, :lastName1, :name2, :lastName2, :studentID1, :studentID2, :pref1, :pref2, :pref3, :lockerNum, :buildingNum)
    end

    def check_admin
      if !is_admin?
        redirect_to "/admin_login"
      end
    end

    def compress(path)
      path.sub!(%r[/$],'')
      archive = File.join(path,File.basename(path))+'.zip'
      FileUtils.rm archive, :force=>true

      Zip::File.open(archive, 'w') do |zipfile|
        Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
          zipfile.add(file.sub(path+'/',''),file)
        end
      end
    end

    def checkValidPerson(firstName, lastName, id)
      student = CvhsLocker.find_by studentID1: id
      student = CvhsLocker.find_by studentID2: id if !student  
      return false, "#{firstName} #{lastName} (#{id}) is already registered for a locker." if student

      student = Student.find_by student_id: id
      return false, "#{firstName} #{lastName} (#{id}) is not a student" if !student

      return false, "#{firstName} #{lastName} (#{id}) is not a student" if !(student[:first_name].casecmp(firstName) == 0 && student[:last_name].casecmp(lastName))

      return true, student[:grade]
    end

    def getAvailableBuilding(pref1, pref2, pref3)
      return pref1 if LockersDb.find_by building: pref1
      return pref2 if LockersDb.find_by building: pref2
      return pref3 if LockersDb.find_by building: pref3
    end

    def getLockerNum(building)
      list = LockersDb.where(building: building)
      locker = list.first
      if !list.second
        r = Restriction.first
        r.full_buildings = r.full_buildings.concat(" #{building}")
        r.save
      end
      number = locker[:locker_id]
      unique = locker[:unique]
      locker.delete
      return number, unique
    end
end
