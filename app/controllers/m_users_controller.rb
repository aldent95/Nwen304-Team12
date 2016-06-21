class MUsersController < ApplicationController
  before_action 'auth_expried?', only: [:update]
  require 'json'
  def new
    @user = MUser.new
  end

  def create
    @user = MUser.new(user_params)
    if @user.save
      render json: {
          status: 200,
          message: "User Successfully Created"
      }.to_json
    else
      render json: {
          status: 400,
          message: "Unable to create new user",
          data: @user.errors
      }.to_json
    end
  end

  def show
    user = MUser.find(params[:id])
    obj = {name:user.name, email:user.email, id:user.id}
    msg = { :status_code => "200", :status=>:ok,:success => "success", :data => obj}
    render json: msg
  end

  def index
    render :json => MUser.all, :except => [:password_digest, :auth_digest, :auth_sent_at, :reset_sent_at, :reset_digest]
  end

  private

  def auth_expried?
    user = MUser.find(params[:id])
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

  def user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation)
  end
end
