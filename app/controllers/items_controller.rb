class ItemsController < ApplicationController

  #before_filter :login_required
  #before_filter :confirm_admin, :except=>[:index,:autocomplete]


	def index
    @others = Items.all
    @index = Items.new
    #@item=CartItem.where(cart_id: initialize_cart).to_a
    @item=CartItem.all

    $total = CartItem.sum('subtotal')


    if params[:query].present?
       @items = Items.search(params[:query],fields: [{name: :text_start}])
       #@items = render json: Items.search(params[:query], autocomplete: true, limit: 10).map(&:name)
       #@items = Items.search(params[:query], page: params[:page])
       #render xml: @items
       $quantity = params[:quantity]


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

=begin
def autocomplete
  @items = Items.autocomplete(:name, params[:q])
  respond_to do |format|
    format.json { render json: @items }
  end
end

  def autocomplete
    @items = Items.search(params[:query], page: params[:page],autocomplete: true, limit: 10).map(&:name)

    @items_hash = []
    @items.each do |b|
        @items_hash << b
    end
     render xml: @items_hash
     flash[:notice]="hahaha"
  
  end
=end

  def show
    @items=Items.all
  end

  def new
    @items = Items.new
  end

  def view_stock
    @items=Items.all
  end

  def create
    @items = Items.new(params[:items].permit(:name, :price, :quantity))
    if @items.save
      flash[:notice1] = "New Item Added"
         #flash[:color] = "invalid"
      redirect_to new_item_path
    else
        
      flash[:notice2] = "Missing fields"
      redirect_to new_item_path
         #flash[:color] = "valid"
    end
         #render "new"
  end



  def cart_item
   
      item = Items.find(params[:items_id])

      
      
      if CartItem.exists?(:cart_id => initialize_cart.id, :items_id => item.id)
        item = CartItem.find(:first, :conditions => [ "cart_id = #{initialize_cart.id} AND items_id = #{item.id}" ])
        CartItem.update(item.id, :quantity => item.quantity.to_i+$quantity.to_i, :subtotal =>(item.quantity.to_i+$quantity.to_i)*item.price)
        flash[:notice] = "updated quantity"
      
      else
        @cart_item = CartItem.create!(:cart => initialize_cart, :items => item, :name=>item.name, :quantity => $quantity, :price => item.price, :subtotal=>$quantity.to_i*item.price.to_i)
        
        logger = Logger.new('log/transaction.log')
        loggerinfo = File.open('log/transaction.log', 'r')
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
      
      redirect_to items_path

  end


  
  def update
    @items=Items.find(params[:id])
    if @items.update(params[:post].permit(:title, :text))
        redirect_to @post

    else
        render "edit"
    end
  end


end
