class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, :only => :changeRestriction

  def changeRestriction

      for i in 0..9
        current_floor = 'floor' + i.to_s
        puts "GRADE IS: #{params[:grade]} and FLOOR IS #{params[current_floor]}"
      end

      redirect_to '/index', notice: "Settings Updated!"
  end

end
