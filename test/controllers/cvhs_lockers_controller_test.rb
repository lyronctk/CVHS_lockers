require 'test_helper'

class CvhsLockersControllerTest < ActionController::TestCase
  setup do
    @cvhs_locker = cvhs_lockers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cvhs_lockers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cvhs_locker" do
    assert_difference('CvhsLocker.count') do
      post :create, cvhs_locker: { name1: @cvhs_locker.name1, name2: @cvhs_locker.name2, number: @cvhs_locker.number, studentID1: @cvhs_locker.studentID1, studentID2: @cvhs_locker.studentID2 }
    end

    assert_redirected_to cvhs_locker_path(assigns(:cvhs_locker))
  end

  test "should show cvhs_locker" do
    get :show, id: @cvhs_locker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cvhs_locker
    assert_response :success
  end

  test "should update cvhs_locker" do
    patch :update, id: @cvhs_locker, cvhs_locker: { name1: @cvhs_locker.name1, name2: @cvhs_locker.name2, number: @cvhs_locker.number, studentID1: @cvhs_locker.studentID1, studentID2: @cvhs_locker.studentID2 }
    assert_redirected_to cvhs_locker_path(assigns(:cvhs_locker))
  end

  test "should destroy cvhs_locker" do
    assert_difference('CvhsLocker.count', -1) do
      delete :destroy, id: @cvhs_locker
    end

    assert_redirected_to cvhs_lockers_path
  end
end
