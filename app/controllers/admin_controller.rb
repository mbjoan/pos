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
    #send_data 'log/transaction.log', :type => 'text/log', :disposition => 'inline'

    send_data('Hello, pretty world :(', 
              :type => 'text/plain', :disposition => 'attachment', :filename => 'log/transaction.log')

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
        @user.errors.full_messages.each do |message_error|   
          flash[:notice2] = message_error
          redirect_to :controller=>"admin", :action=>"new" 
          return false 
        end

      end
  end



end
