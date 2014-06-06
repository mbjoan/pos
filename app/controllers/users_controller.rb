class UsersController < ApplicationController

before_filter :login_required, :except=>[:index, :login]
before_filter :confirm_admin, :only=>[:new, :view_user, :show]

autocomplete :users, :username

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


  def create
    @user = User.new(params[:user].permit(:username, :role, :password, :password_confirmation))
    if @user.save
       flash[:notice] = "New user created"
       #flash[:color] = "invalid"
       #redirect_to root_url, :notice => "signed up"
    else
      
       flash[:notice] = "Form is invalid-empty fields"
       redirect_to new_admin_path
       #flash[:color] = "valid"
    end
       #render "new"
       #redirect_to admin_index_path
  end


  def login
    if request.post?
      user = User.authenticate(params[:username], params[:password])
        if user
          session[:user] = user.id
          session[:role] = user.role
          session[:user_name]= user.username
          flash[:notice] = "WELCOME "+session[:user_name]
          #redirect_to new_user_path

            if session[:role]=="Admin"
              redirect_to admin_index_path
              return true
            elsif session[:role]=="Cashier"
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
      session[:user] = nil
      #redirect_to home_url, :notice => "Logged out"
      #flash[:notice] = 'Logged out'
      flash[:notice] = 'Logged out successfully'
      redirect_to users_path

end

def destroy
  @user=User.find(params[:id])

  @user.destroy
  flash[:notice1] = 'Deleted User '+ @user.username
  
  redirect_to users_view_user_path

end


 private
  def post_params
    params.require(:post).permit(:title, :text)
  end


end
