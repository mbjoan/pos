class ItemsController < ApplicationController

  #before_filter :login_required
  #before_filter :confirm_admin, :except=>[:index,:autocomplete]
  protect_from_forgery


	def index
    @others = Items.all
    @index = Items.new
    #@item=CartItem.where(cart_id: initialize_cart).to_a
    @item=CartItem.all

    $total = CartItem.sum('subtotal')

    if params[:text].present?
      if params[:quantity].present?
        @items = Items.where(:name=>params[:text])
        $quantity = params[:quantity]
        
        if @items
          item = Items.find_by_name(params[:text])    
          if item.quantity.to_i>$quantity.to_i

            if CartItem.exists?(:cart_id => initialize_cart.id, :items_id => item.id)
              item = CartItem.find(:first, :conditions => [ "cart_id = #{initialize_cart.id} AND items_id = #{item.id}" ])
              CartItem.update(item.id, :quantity => item.quantity.to_i+$quantity.to_i, :subtotal =>(item.quantity.to_i+$quantity.to_i)*item.price)
              flash[:notice] = "updated quantity"
              Items.update(item.id, :quantity => item.quantity.to_i-$quantity.to_i)
          
            else
              @cart_item = CartItem.create!(:cart => initialize_cart, :items => item, :name=>item.name, :quantity => $quantity, :price => item.price, :subtotal=>$quantity.to_i*item.price.to_i)
              Items.update(item.id, :quantity => item.quantity.to_i-$quantity.to_i)
              logger = Logger.new('log/transaction.pdf')
              loggerinfo = File.open('log/transaction.pdf', 'r')
              if loggerinfo == nil              
                logger.info("Item   |   Quantity  |  Unit Price   |  Total    |   Cashier")
                logger.info("------------------------------------------------------------")

                logger.info(item.name.to_s+"    |   "+$quantity.to_s+"    |   "+item.price.to_s+"    |   "+$total.to_s)
                 logger.close
              else
                logger.info(item.name.to_s+"    |   "+$quantity.to_s+"    |   "+item.price.to_s+"    |   "+($quantity.to_i*item.price.to_i).to_s)
                puts " hhaa"
                logger.close
              end
          
                flash[:notice] = "Added #{item.name} to cart."
            end

          else
            flash[:notice1] = "Item out of stock"
          end
      
        redirect_to items_path
      end
    end


  return @items
    else
    	#@items = Items.search(params[:query])
      myarray = Items.all
      @items = Kaminari.paginate_array(myarray).page(params[:page])
     #@items = Items.all params[:query]
    end
  end

  def new_sale
    CartItem.delete_all
    Cart.delete_all
    session[:cart_id]=nil
    redirect_to items_path
  end


  def autocomplete
    render json: Items.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end


  def show
    @items=Items.all
  end

  def new
    @items = Items.new
    $name = params[:name]
  end

  def view_stock
    @items=Items.all
  end

  def create
    @items = Items.new(params[:items].permit(:name, :price, :quantity))
    if @items.save
      flash[:notice1] = "New Item Added"
      redirect_to new_item_path
    else
      @items.errors.full_messages.each do |message_error|   
        flash[:notice2] = message_error
        redirect_to new_item_path
        return false 
        end
  
    end
  end

 def destroy
  @item = Items.find(params[:id])
  if @item.destroy
    flash[:notice] = "Item deleted"
      redirect_to items_view_stock_path
  else
    flash[:notice1] = "Failed to delete Item"
  end
end
end
