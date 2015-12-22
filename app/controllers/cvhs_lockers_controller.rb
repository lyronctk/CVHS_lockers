class CvhsLockersController < ApplicationController
  before_action :set_cvhs_locker, only: [:show, :edit, :update, :destroy]

  # GET /cvhs_lockers
  # GET /cvhs_lockers.json
  def index
    @cvhs_lockers = CvhsLocker.paginate(page: params[:page])
  end

  # GET /cvhs_lockers/1 
  # GET /cvhs_lockers/1.json
  def show
  end

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

    respond_to do |format|
      if @cvhs_locker.save
        format.html { redirect_to '/success'}
        format.json { render :new, status: :created, location: @cvhs_locker }
      else
        format.html { render :new }
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
      format.html { redirect_to cvhs_lockers_url, notice: 'Cvhs locker was successfully destroyed.' }
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
      params.require(:cvhs_locker).permit(:name1, :name2, :studentID1, :studentID2, :pref1, :pref2, :pref3, :pref4, :pref5)
    end
end
