class ListingsController < ApplicationController
  before_action 'auth_expried?', only: [:create, :seller, :buyer, :destroy]

  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = params[:user_id]
    if @listing.save
      render json: {
          status: 200,
          message: "Item Successfully Created",
          data: @listing.id
      }.to_json
    else
      render json: {
          status: 400,
          message: "Unable to create new item",

      }.to_json
    end
  end

  def show
    render json: Listing.find(params[:id])
  end

  def index
    render json: Listing.all
  end

  def active
    render json: Listing.where(:purchaser_id => nil)
  end

  def seller
    render json: Listing.where(:user_id => params[:user_id])
  end

  def buyer
    render json: Listing.where(:purchaser_id => params[:user_id])
  end

  def destroy
    listing = Listing.find(params[:id])
    if listing.purchaser_id == nil
      listing.destroy
      render json: {
          status: 200,
          message: "Listing deleted"
      }.to_json
    else
      render json: {
          status: 403,
          message: "Cannot delete item that has been purchased"
      }.to_json
    end
  end

  def update
    listing = Listing.find(params[:id])
    if listing.purchaser_id == nil
      if params[:user_id].to_i == listing.user_id
        render json: {
            status: 403,
            message: "Cannot Purchase your own item"
        }.to_json
      else
        if params[:payment_type] == nil
          render json: {
              status: 400,
              message: "Missing payment type"
          }.to_json
        else
          listing.update_attribute(:purchaser_id, params[:user_id])
          listing.update_attribute(:payment_type, params[:payment_type])
          render json: {
              status: 200,
              message: "Item Purchased"
          }.to_json
        end

      end

    else
      render json: {
          status: 403,
          message: "Item Already Purchased"
      }.to_json
    end
  end


  private

  def listing_params
    params.require(:listing).permit(:title, :description, :category, :imageurl, :price)
  end

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

end
