class UsersController < ApplicationController
  before_action :hide_header
  skip_before_action :require_login, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Welcome! You￥\'ve successfully signed in.'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      redirect_to signup_path
    end
  end

  def toggle_writing_assist
    @user.writing_assist_enabled = !@user.writing_assist_enabled
    if @user.save
      if @user.writing_assist_enabled
        redirect_back(fallback_location: root_path, notice: 'Changed to public account.')
      else
        redirect_back(fallback_location: root_path, notice: 'Changed to private account.')
      end
    else
      redirect_back(fallback_location: root_path, alert: 'Failed to change public range.')
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end

    def hide_header
      @show_header = false
    end

    def set_user
      @user = User.find(params[:id])
    end
end
