class CvhsLockersController < ApplicationController
  before_action :set_cvhs_locker, only: [:show, :edit, :update, :destroy]

  # GET /cvhs_lockers
  # GET /cvhs_lockers.json
  def index
      if params[:search] == nil
         @cvhs_lockers = CvhsLocker.paginate(page: params[:page])
      else
         @cvhs_lockers = CvhsLocker.find_by studentID1: params[:search]

         if @cvhs_lockers == nil
            @cvhs_lockers = CvhsLocker.find_by studentID2: params[:search]
         end
      end
  end

  # GET /cvhs_lockers/1 
  # GET /cvhs_lockers/1.json
  def success
  end

  # GET /cvhs_lockers/new
  def new
    @cvhs_locker = CvhsLocker.new
  end

  # GET /cvhs_lockers/1/edit
  def edit
  end

  # POST /cvhs_lockers
  # POST /cvhs_lockers.json
  def create
    @cvhs_locker = CvhsLocker.new(cvhs_locker_params)

    # CREATE PARAMETERS FOR LOCKERMASTER
    locker_array = [cvhs_locker_params[:pref1], cvhs_locker_params[:pref2], cvhs_locker_params[:pref3]]
    person1_array = [cvhs_locker_params[:name1], cvhs_locker_params[:lastName1], cvhs_locker_params[:studentID1]]
    person2_array = [cvhs_locker_params[:name2], cvhs_locker_params[:lastName2], cvhs_locker_params[:studentID2]]

    master = (LockerMaster).new(File.join(Rails.root, 'lib', 'CVHS Locker Template and Guide'), File.join(Rails.root, 'lib', 'Student locator fall 2015'))
    
    # STORES VALIDATION AND LOCKER INFORMATION
    allowed = master.createLocker(locker_array, person1_array, person2_array)

    if(allowed[0])
      @cvhs_locker[:lockerNum] = allowed[1][0];
      @cvhs_locker[:buildingNum] = allowed[1][1];
    end
    
    respond_to do |format|
      if allowed[0]
        if @cvhs_locker.save

          # PASS IN RECEPIT INFORMATION
          session[:name1] = cvhs_locker_params[:name1]
          session[:lastName1] = cvhs_locker_params[:lastName1]
          session[:name2] = cvhs_locker_params[:name2]
          session[:lastName2] = cvhs_locker_params[:lastName2]
          session[:lockerNum] =  allowed[1][0]
          session[:buildingNum] = allowed[1][1]

          redirect_to '/success' and return;
          format.json { render :new, status: :created, location: @cvhs_locker }
        end
      else
        puts "REJECTED"
        format.html { redirect_to '/', notice: allowed[1] }
        format.json { render json: @cvhs_locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cvhs_lockers/1
  # PATCH/PUT /cvhs_lockers/1.json
  def update
    respond_to do |format|
      if @cvhs_locker.update(cvhs_locker_params)
        format.html { redirect_to @cvhs_locker, notice: 'Cvhs locker was successfully updated.' }
        format.json { render :show, status: :ok, location: @cvhs_locker }
      else
        format.html { render :edit }
        format.json { render json: @cvhs_locker.errors, status: :unprocessable_entity }
      end
    end
  end       

  # DELETE /cvhs_lockers/1
  # DELETE /cvhs_lockers/1.json
  def destroy
    @cvhs_locker.destroy
    respond_to do |format|
      format.html { redirect_to cvhs_lockers_url, notice: 'Locker was successfully deleted.' }
      format.json { head :no_content }
    end
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
end
