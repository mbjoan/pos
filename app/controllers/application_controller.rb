class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :current_user

  #prohibiting access through url for unauthorized users
	def login_required
		if session[:userid]
			return true			
		end
		flash[:notice1]="Please login to continue"
		redirect_to users_path
		return false
	end

  #checking if a user is an administrator
  def confirm_admin
    unless session[:role] && session[:role]=='Admin'
  	  flash[:notice1] ="you do not have the required priviledges to access this page."
  	  redirect_to items_path
  	  return false # deny access
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
      #create new cart
      @cart = Cart.create
      session[:cart_id] = @cart.id
      @cart
    end
  end
end
