class MUsersController < ApplicationController
  def new
    @user = MUser.new
  end

  def create
    @user = MUser.new(user_params)
    if @user.save
      log_in @user
      render json: {
          status: 200,
          message: "User Successfully Created"
      }.to_json
    else
      render json: {
          status: 400,
          message: "Unable to create new user",

      }.to_json
    end
  end


  private

  def user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation)
  end
end
