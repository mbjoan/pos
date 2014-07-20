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
       @items = Items.where(:name=>params[:text])
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
        
      flash[:notice2] = "Missing fields"
      redirect_to new_item_path
    end
  end



  def cart_item
   
      item = Items.find(params[:items_id])

      
      if item.quantity.to_i>$quantity.to_i

          if CartItem.exists?(:cart_id => initialize_cart.id, :items_id => item.id)
            item = CartItem.find(:first, :conditions => [ "cart_id = #{initialize_cart.id} AND items_id = #{item.id}" ])
            CartItem.update(item.id, :quantity => item.quantity.to_i+$quantity.to_i, :subtotal =>(item.quantity.to_i+$quantity.to_i)*item.price)
            flash[:notice] = "updated quantity"
            Items.update(item.id, :quantity => item.quantity.to_i-$quantity.to_i)


          
          else
            @cart_item = CartItem.create!(:cart => initialize_cart, :items => item, :name=>item.name, :quantity => $quantity, :price => item.price, :subtotal=>$quantity.to_i*item.price.to_i)
            Items.update(item.id, :quantity => item.quantity.to_i-$quantity.to_i)
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

        else
          flash[:notice1] = "Item out of stock"
        end
      
      redirect_to items_path

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

def transact

url = URI.parse('https://41.190.131.222/pegpaytelecomsapi/PegPayTelecomsApi.asmx?WSDL')
       
    post_xml ='<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <PostTransaction xmlns="http://PegPayTelecomsApi/">
          <trans>
            <DigitalSignature>'+ "#{digital_signature_new}" +'</DigitalSignature>
            <FromTelecom>'+ "#{params[:customer_tarrif]}" +'</FromTelecom>
            <ToTelecom>'+ "#{params[:system_tarrif]}" +'</ToTelecom>
            <PaymentCode>1</PaymentCode>
            <VendorCode>MABIRA</VendorCode>
            <Password>81W30DI846</Password>
            <PaymentDate>'+ Date.today.strftime("%m/%d/%Y")  +'</PaymentDate>
            <Telecom></Telecom>
            <CustomerRef>'+"#{params[:customer_number]}"+'</CustomerRef>
            <CustomerName>'+"iconics"+'</CustomerName>
            <TranAmount>'+"#{$total}"+'</TranAmount>
            <TranCharge>0</TranCharge>
            <VendorTranId>1</VendorTranId>
            <ToAccount></ToAccount>
            <FromAccount>'+"#{params[:customer_number]}"+'</FromAccount>
            <TranType>PULL</TranType>
          </trans>
        </PostTransaction>
      </soap:Body>
    </soap:Envelope>'

          peg_pay_status_code = make_http_request(url, post_xml)
            puts "status code============================================"           
              puts peg_pay_status_code
            puts "status code============================================"
  #  ******* end of sending request to yo! payments server ******************
           message=getTransactionStatus(peg_pay_status_code )
           message

           #=============================== error=============================
           flash[:notice1] = 'Thank you for your order.'
           redirect_to items_path
=begin
      respond_to do |format|
        #if peg_pay_status_code == 0
          if @order.save
            Cart.destroy(session[:cart_id])
            session[:cart_id] = nil
            Notifier.order_received(@order).deliver
            flash[:notice] = 'Thank you for your order.' 
            format.html { redirect_to(:controller=>'main', :action=>'index') }
            format.json { render json: @order, status: :created, location: @order }
          else
            format.html { render action: "new" }
            format.json { render json: @order.errors, status: :unprocessable_entity }
          end
        #else
        #  flash[:notice]= message

        #  format.html { render action: "new" }
        #  format.json { render json: @order.errors, status: :unprocessable_entity }
       # end
    end
=end
  end


  #=============================== error=============================

  def make_http_request(uri, post_xml)
    require 'net/http'
    require 'open-uri'

    peg_pay_status_code = ""
    conn = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path)
       if uri.scheme == 'https'
        require 'net/https'
        conn.use_ssl = true
              conn.verify_mode = OpenSSL::SSL::VERIFY_NONE   # needed for windows environment
      end
    request.body=post_xml
    request.content_type = 'text/xml'
    response = conn.request(request)
    
    peg_pay_status_code = response.read_body
    peg_pay_status_code

  end
  def getTransactionStatus(statusCode)
    returnMessage=""
    if statusCode=="0"
            returnMessage="SUCCESS"
    else
      returnMessage= statusCode
    end
        
    return returnMessage
  end

  def digital_signature_new
    require 'openssl'
    require 'base64'
    require 'digest/sha1'

    @date = Date.today.strftime("%m/%d/%Y")
    #text_to_sign = "#{params[:customer_number]}" + "iconics" + "#{@order.pay_type}" + "#{@order.pay_type}" + "1" + "MABIRA" + "81W30DI846" + "#{@date}" + "PULL" + "1" + "#{$total}" + "#{params[:customer_number]}" + ""
    text_to_sign = "#{params[:customer_number]}" + "iconics" + "#{params[:customer_tarrif]}" + "#{params[:system_tarrif]}" + "1" + "Mabira" + "81W30DI846" + "#{@date}" + "PULL" + "1" + "#{$total}" + "#{params[:system_number]}"+ ""
    #text_to_sign = "0775084688" + "Becka" + "MTN" + "MTN" + "1" + "Mabira" + "81W30DI846" + "12345678" + "PULL" + "1" + "2000000" + "0775084688" + " "
    password = 'Tingate710'

    cipher = OpenSSL::Cipher.new 'aes-256-cbc'
    cipher.encrypt
    cipher.key = cipher.random_key
    cipher.iv = cipher.random_iv

    encrypted = cipher.update(text_to_sign) + cipher.final
    #encrypted << cipher.final
    hashed_text = Digest::SHA1.hexdigest(encrypted)
    private_key = OpenSSL::PKey::RSA.new(File.read('Mabira.key'), password)
    ciphertext = private_key.private_encrypt(hashed_text)
    ciphertext.encoding
    signed_text = Base64.encode64(ciphertext).gsub("\n", '')
    puts signed_text
    signed_text

  end






end
