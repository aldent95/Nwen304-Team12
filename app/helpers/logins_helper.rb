module LoginsHelper
  def log_in(user)
    session[:user_id] = user.id
    user.create_auth_digest


  end
  def current_user
    @current_user ||= MUser.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end


  private
    def valid_auth

    end
    def check_expiration

    end

end
