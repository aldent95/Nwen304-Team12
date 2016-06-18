class LoginsController < ApplicationController
  before_action 'auth_expried?', only: [:destroy]
  def new
  end

  def create
    user = MUser.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      render json: {
          status: 200,
          message: "Logged in",
          data: {"auth":user.auth_token, "id":user.id}
      }.to_json
      # Log the user in and redirect to the user's show page.
    else
      render json: {
          status: 400,
          message: "Invalid email/password combination",
          data: auth
      }.to_json
    end
  end

  def destroy
    log_out MUser.find(params[:user_id])
    render json: {
        status: 200,
        message: "User Logged out",
    }.to_json
  end

  private

end
