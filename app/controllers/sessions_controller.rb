class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to projects_url
    else
      redirect_to login_url, alert: 'Invalid email or password'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/', notice: 'You have been logged out.'
  end
end
