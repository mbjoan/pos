class AdminController < ApplicationController
	
  before_filter :confirm_admin

	def index
	end


  	def new
    	@user = User.new
  	end

    def show
    end

    def help
    end

	  def create
    @user = User.new(params[:user].permit(:username, :role, :password, :password_confirmation))
    if @user.save
       flash[:notice1] = "New user created"
       #flash[:color] = "invalid"
       redirect_to new_admin_path
       #redirect_to root_url, :notice => "signed up"
    else
      
       flash[:notice2] = "Missing fields"
       redirect_to new_admin_path
       #flash[:color] = "valid"
    end
       #render "new"
  end

end
