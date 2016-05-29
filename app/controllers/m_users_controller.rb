class MUsersController < ApplicationController
  def new
    @user = MUser.new
  end

  def create
    @user = MUser.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Welcome to the NWEN304 Team 12 App!"
      redirect_to root_path
    else
      render 'new'
    end
  end


  private

  def user_params
    params.require(:m_user).permit(:name, :email, :password, :password_confirmation)
  end
end
