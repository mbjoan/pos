class Items < ActiveRecord::Base

	#attr_accessor :name, :price, :quantity

	
	searchkick autocomplete: ['name']
	#searchkick

	validates :name, :presence => true, :uniqueness => true
	validates :price, :presence => true
	validates :quantity, :presence => true

	has_many :cart_items
  	has_many :carts, :through => :cart_items



end
