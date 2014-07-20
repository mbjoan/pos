class AdminController < ApplicationController
	
  #before_filter :confirm_admin, :except=>[:help]

	def index
	end


  def new
    	@user = User.new
  end

  def show
  end

  def help
  end

  #read transaction log file
  def read_log
    @contents = File.read("log/transaction.log")
    @next = @contents.to_s
    @final= @next.split("I,")
    $reader=""
    @final.each do|read|
      $reader = read+"\n"
      puts $reader
    end
    #File.readlines('foo').each do |line|

    counter = 1
    @file = File.new("log/transaction.log", "r")
    while (line = @file.gets)
        put= "#{counter}: #{line}"
        @line = ""
        @line+put+","
        counter = counter + 1               
    end
    @file.close 
  end

  def download_file

  end

  #create new system user
	def create
    @user = User.new(params[:user].permit(:username, :role, :password, :password_confirmation))
      if @user.save #save the user
        flash[:notice1] = "New user created"
        redirect_to new_admin_path
      else   
        flash[:notice2] = "Missing fields"
        redirect_to new_admin_path
      end
  end


end
