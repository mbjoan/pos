class CartItem < ActiveRecord::Base

	#attr_accessor :name, :price, :quantity, :cart_id, :items_id

	belongs_to :cart
  	belongs_to :items

end
