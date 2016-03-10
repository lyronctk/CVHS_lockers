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
    apprentice = (LockerApprentice).new(File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide'))
    floors = apprentice.getFilledFloors();
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

  # SWITCH OUT STUDNET LOCATOR
  def upload
    uploaded_io = params[:database_file]

    File.open(Rails.root.join('lib', 'student_locator.xlsx'), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    redirect_to '/index', :notice => "Student Locator successfully replaced"
  end

  # POST /cvhs_lockers
  # POST /cvhs_lockers.json
  def create
    @cvhs_locker = CvhsLocker.new(cvhs_locker_params)
    grade_restriction = Restriction.first[:grades]

    master = (LockerMaster).new(File.join(Rails.root, 'lib', "CVHS Locker Template and Guide"), File.join(Rails.root, 'lib', 'student_locator'))

    # CREATES INFO FOR LOCKER MASTER
    person1_array = [cvhs_locker_params[:name1], cvhs_locker_params[:lastName1], cvhs_locker_params[:studentID1]]
    person2_array = [cvhs_locker_params[:name2], cvhs_locker_params[:lastName2], cvhs_locker_params[:studentID2]]
    locker_array = [cvhs_locker_params[:pref1], cvhs_locker_params[:pref2], cvhs_locker_params[:pref3]]

    if(!master.checkRealPerson(person1_array))
      redirect_to '/new', notice: "#{person1_array[0]} #{person1_array[1]} (#{person1_array[2]}) is not a student." and return
    end

    if(!master.checkRealPerson(person2_array))
      redirect_to '/new', notice: "#{person2_array[0]} #{person2_array[1]} (#{person2_array[2]}) is not a student." and return
    end

    if grade_restriction && (master.getGradeLvl(person1_array).to_i >= grade_restriction || master.getGradeLvl(person2_array).to_i >= grade_restriction)
      if @cvhs_locker[:name2]  == "" 
        allowed = master.createSoloLocker(["1300_SINGLES"], person1_array)
      else
        # STORES VALIDATION AND LOCKER INFORMATION
        allowed = master.createLocker(locker_array, person1_array, person2_array)
      end

      if(allowed[0])
        @cvhs_locker[:lockerNum] = allowed[1][1];
        @cvhs_locker[:buildingNum] = allowed[1][0];
      end
    else
      allowed = false, "Your grade level is not permitted to register yet."
    end

    
    respond_to do |format|
      if allowed[0]
        if @cvhs_locker.save

          # PASS IN RECEPIT INFORMATION
          session[:name1] = cvhs_locker_params[:name1]
          session[:lastName1] = cvhs_locker_params[:lastName1]
          session[:name2] = cvhs_locker_params[:name2]
          session[:lastName2] = cvhs_locker_params[:lastName2]
          session[:lockerNum] =  allowed[1][1]
          session[:buildingNum] = allowed[1][0]

          redirect_to '/success' and return;
          format.json { render :new, status: :created, location: @cvhs_locker }
        end
      else
        format.html { redirect_to '/new', notice: allowed[1] }
        format.json { render json: @cvhs_locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cvhs_lockers/1
  # DELETE /cvhs_lockers/1.json
  def destroy
    master = (LockerMaster).new(File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide'), File.join(Rails.root, 'lib', 'student_locator'))
    master.deleteLocker(@cvhs_locker.studentID1);

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
end
