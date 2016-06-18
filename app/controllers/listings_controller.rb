class ListingsController < ApplicationController
  before_action 'auth_expried?', only: [:create]

  def create
    @listing = Listing.new(listing_params)
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
