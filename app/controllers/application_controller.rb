class ApplicationController < ActionController::Base
  before_action :require_login, :set_header_visibility, :set_current_user, :set_locale
  include SessionsHelper
  
  def redirect_to_current_date
    redirect_to diary_by_date_path(date: Date.today)
  end
  private

  def require_login
    unless logged_in?
      redirect_to login_url
    end
  end

  def logged_in?
    session[:user_id].present?
  end

  def set_header_visibility
    @show_header = true
  end

  def set_current_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
