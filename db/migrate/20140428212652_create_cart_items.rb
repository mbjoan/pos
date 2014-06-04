class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|

    	t.integer :items_id
    	t.integer :cart_id
    	t.string :name
      t.integer :price
      t.integer :quantity
      t.integer :subtotal


      	t.timestamps
    end
  end
end
