class HomeController < ApplicationController
  def index
  end

  def login_required
    render 'login_error'
  end
end
