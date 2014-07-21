class UsersController < ApplicationController

before_filter :login_required, :except=>[:index, :login]
before_filter :confirm_admin, :only=>[:new, :view_user, :show]

  def index
  end

  def new
    @user = User.new
  end

  def show
    @users=User.all
  end

  def view_user
    @users=User.all
  end

  #create new user
  def create
    
  end

  #login method
  def login
    if request.post?
      #authenticate user
      user = User.authenticate(params[:username], params[:password])
        if user
          #set sessions objects for the user
          session[:userid] = user.id
          session[:role] = user.role
          session[:user_name]= user.username
          flash[:notice] = "WELCOME "+session[:user_name]

          if session[:role]=="Admin"
            #redirect to admin page
            redirect_to admin_index_path
            return true
          elsif session[:role]=="Cashier"
            #redirect to cashier page
            redirect_to items_path
            return true
          end
        else
          flash[:notice1] = "Wrong Username or password"
          redirect_to :controller=>'users'
        end
    end

  end

def logout
  #destroy session objects
  session[:userid] = nil
  session[:role] = nil
  session[:user_name]= nil
  flash[:notice] = 'Logged out successfully'
  redirect_to users_path
end

#delete user
def destroy
  @user=User.find(params[:id])

  @user.destroy
  flash[:notice] = 'Deleted User '+ @user.username
  
  redirect_to users_view_user_path

end


 private
  def post_params
    params.require(:post).permit(:title, :text)
  end


end
