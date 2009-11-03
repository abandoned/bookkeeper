class CartsController < ApplicationController
  before_filter :require_user
  
  def show
    @cart = resource
  end
  
  def update
    if params[:transaction_id]
      transaction = Transaction.find(params[:transaction_id])
      resource.add(transaction)
    end
    respond_to do |format|  
      format.html { redirect_to :action => :show }
      format.js
    end
  end
  
  def destroy
    @cart = session[:cart] = Cart.new
    respond_to do |format|  
      format.html { redirect_to :action => :show }
      format.js
    end
  end
  
  protected
  
  def resource
    @cart ||= cart_in_session
  end
  
  def cart_in_session
    session[:cart] ||= Cart.new
  end
end
