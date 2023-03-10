class CartController < ApplicationController
  before_action :authenticate_user

  def index
    @cart_items = LineItem.where(user_id:current_user.id)
  end

  def empty_cart
    destroy
    respond_to do |format|
      format.html { redirect_to '/cart/index', notice: "Cart Empty" }
      format.json { head :no_content }
    end
  end

  def checkout
    if(session[:amount]==0)
      flash[:notice]="Your cart is empty. Add your favourite product to cart before it goes out of stock."
      redirect_to "/gallery/index"
      return
    else
      amount_to_charge = session[:amount].to_i
      if request.post?
        ActiveMerchant::Billing::Base.mode = :test
        # ActiveMerchant accepts all amounts as Integer values in cents
        #amount = 100
        credit_card = ActiveMerchant::Billing::CreditCard.new(:first_name=> params[:first_name],:last_name=> params[:last_name],:number=> params[:card_no].to_i,:month=> params[:check][:month].to_i,:year=> params[:check][:year].to_i,:verification_value => params[:cvv].to_i)
        # Validating the card automatically detects the card type
        gateway =ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password =>'password',
        :test => 'true' )
        response = gateway.authorize(amount_to_charge , credit_card)
        #response = gateway.purchase(amount_to_charge, credit_card)
        puts response.inspect
        if response.success?
          gateway.capture(amount_to_charge, response.authorization)
          NotifierMailer.with(user:current_user,amount:session[:amount]).purchase_complete.deliver
          destroy
          session.delete(:amount)
          session[:payment_successful] = true
          redirect_to "/cart/thankyou_page"
        else
          flash[:alert]= "Something went wrong.Try again"
          render :checkout
        end
      end
    end
  end

  def destroy
    @cart_items = LineItem.where(user_id:current_user.id)
    @cart_items.delete_all
  end

  def thankyou_page
    if(!session[:payment_successful])
      redirect_to '/gallery/index'
      return
    end
    session[:payment_successful]=false
  end

  private
  def authenticate_user
    if(!user_signed_in?)
      flash[:notice]="Please login to continue shopping."
      redirect_to "/users/sign_in"
      return
    end
  end
end
