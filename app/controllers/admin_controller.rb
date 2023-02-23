class AdminController < ApplicationController
  def login
    if(request.post?)
      if(params[:email]=="admin@watchsy.com" && params[:password]=="admin123")
        session[:admin] = "admin_watchsy"
        redirect_to "/stores"
      else
        flash[:error] = "Invalid credentials"
        render :login
      end
    end
  end

  def logout
    session.delete(:admin)
    render 'admin/login'
  end
end
