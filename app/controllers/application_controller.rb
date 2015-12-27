class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_for_mobile
  	session[:mobile_override] = params[:mobile] if params[:mobile]
  end

  def mobile_device?
  	if session[:mobile_override]
  		session[:mobile_override] == "1"
  	else
  		(request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
  	end
  end
end
