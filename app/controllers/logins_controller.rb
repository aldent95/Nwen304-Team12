class LoginsController < ApplicationController
  def new
  end

  def create
    user = MUser.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      auth = log_in user
      render json: {
          status: 400,
          message: "Unable to create new user",
          data: auth
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
    log_out
    redirect_to root_url
  end

  private

end
