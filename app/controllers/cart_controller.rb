class CartController < ApplicationController
  before_action 'auth_expried?'
  def create
    @cart = Cart.new({:user_id => params[:user_id], :item_id => params[:item_id]})
    if @cart.save
      render json: {
          status: 200,
          message: "Item Successfully Added to cart"
      }.to_json
    else
      render json: {
          status: 400,
          message: "Unable to add item to cart",

      }.to_json
    end
  end

  def update
    cartItems = Cart.where(:user_id => params[:user_id])
    cartItems.each do |item|
      listing = Listing.find(item.item_id)
      failed = purchase(listing)
      if !failed
        render json: {
            status: 400,
            message: "Item pruchase failed at item #{item.item_id}",

        }.to_json
        return
      end
      Cart.where(:user_id => params[:user_id], :item_id => item.item_id).first.destroy
    end
    render json: {
        status: 200,
        message: "All items pruchased",

    }.to_json
  end

  def destroy
    cart = Cart.where(:user_id => params[:user_id], :item_id => params[:item_id]).first
    cart.destroy
    render json: {
        status: 200,
        message: "Item Removed from Cart",

    }.to_json
  end

  def index
    render json: Cart.where(:user_id => params[:user_id])
  end



  private
  def auth_expried?
    user = MUser.find(params[:user_id])
    if user.authenticated?(params[:auth_token])
      if !user.auth_token_expired?
        return
      else
        render json: {
            status: 401,
            message: "Auth token expired, please login again",

        }.to_json
        return
      end

    else
      render json: {
          status: 401,
          message: "Incorrect auth token",

      }.to_json
      return
    end

  end

  def purchase(listing)
    if listing.purchaser_id == nil
      if params[:user_id].to_i == listing.user_id
        return false
      else
        if params[:payment_type] == nil
          return false
        else
          listing.update_attribute(:purchaser_id, params[:user_id])
          listing.update_attribute(:payment_type, params[:payment_type])
          return true
        end

      end

    else
      return false
    end
  end
end
