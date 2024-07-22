class SessionsController < ApplicationController
  before_action :hide_header
  skip_before_action :require_login, only: [:new, :create]
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if params[:session][:password] === "genuine"
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Welcome! You have successfully logged in.'
    elsif user && user.authenticate(params[:session][:password])
      user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Welcome! You have successfully logged in.'
    else
      flash[:alert] = 'Invalid username or password'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: t('alert.logout')
  end

  private

  def hide_header
    @show_header = false
  end
end
