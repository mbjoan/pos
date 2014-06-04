class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.


  protect_from_forgery with: :exception

  helper_method :current_user


	def login_required
		if session[:user]
			return true			
		end
		flash[:notice2]="Please login to continue"
		redirect_to users_path
		return false
	end

  	def confirm_admin
    unless session[:role] && session[:role]=='Admin'
	  flash[:notice2] ="You do not have the required priviledges to access this page."
	  redirect_to items_path
	  return false # halts the before_filter
	else
	  return true
	end
  end

#cart method
  private

  def initialize_cart
    if session[:cart_id]
      @cart = Cart.find(session[:cart_id])
    else
      @cart = Cart.create
      session[:cart_id] = @cart.id
      @cart
    end
  end
 	 
  #logger
  


end
