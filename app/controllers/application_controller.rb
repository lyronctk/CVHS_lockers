class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, :only => :changeRestriction

  helper_method :is_admin?

  def changeRestriction
    # ONLY HAPPENS FIRST UPDATE
    if(!Restriction.first)
      Restriction.create!(grades: 9, floors:"")
    end

    # GETS CHECKBOX VALUES
    restricted_floors = ""
    update = false
    for i in 0..10
      counter_floor = 'floor' + i.to_s

      if counter_floor == "none"
        update = true
        break
      end
      
      if(params[counter_floor])
        restricted_floors += (params[counter_floor]+',')
      end
    end

    if(params[:grade] != "")
      Restriction.first.update_attribute(:grades, params[:grade])
    end

    if(restricted_floors != "" || update) 
      Restriction.first.update_attribute(:floors, restricted_floors)
    end

    # CHECKS IF PASSWORD IS INCORRECT  - CAN'T CHANGE PASSWORDS FOR NOW
    # if(params[:current_password] != "" && params[:current_password] != ENV["PASSWORD"])
    #   redirect_to '/index', notice: "error"
    #   return
    # end


    # if(params[:current_password] != ENV["PASSWORD"] && params[:new_password] == params[:again_password] && params[:new_password] != "")
    #   ENV["PASSWORD"] = params[:new_password]
    # end

    redirect_to '/index', notice: "Settings Updated!"
  end

  def is_admin?
    return true if session[:admin]
  end

end