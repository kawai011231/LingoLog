class DiariesController < ApplicationController
  def show
    render :show
  end

  def index
    if params[:user_id].present?
      @diaries = Diary.where(user_id: params[:user_id]).order(date: :desc)
    else
      if session[:user_id] == 1
        @diaries = Diary.all.order(date: :desc)
      end
      @diaries = Diary.joins(:user).where(users: { writing_assist_enabled: true }).all.order(date: :desc)
    end
    if session[:user_id] == 1
      @users = User.all
    else
      @users = User.where(writing_assist_enabled: true)
    end
  end

  def show_or_new
    @date = Date.parse(params[:date])
    @diary = Diary.find_by(date: @date, user_id: session[:user_id])
    @category = params[:category]
    @prompt = get_random_prompt(@category) if @category 

    unless @diary
      @diary = Diary.new(date: @date)
    end
  end

  def create
    @diary = Diary.new(diary_params)
    @diary.user_id = session[:user_id]
    if @diary.save
      chat_service = ChatGptService.new
      feedback = chat_service.evaluate_diary(@diary.title, @diary.content)
      @diary.update(feedback: feedback)
      redirect_to diary_by_date_path(date: @diary.date.strftime('%Y-%m-%d')), notice: 'You have created a diary.'
    else
      redirect_to root_path, alert: 'You were unable to create a diary. Please contact your administrator.'
    end
  end

  def edit
    @date = Date.parse(params[:date])
    @diary = Diary.find_by(date: @date, user_id: session[:user_id])
  end

  def update
    @date = Date.parse(params[:date])
    logger.debug "Parsed date: #{@date}"
    @diary = Diary.find_by(date: @date, user_id: session[:user_id])
    if @diary.update(diary_params)
      chat_service = ChatGptService.new
      feedback = chat_service.evaluate_diary(@diary.title, @diary.content)
      @diary.update(feedback: feedback)
      redirect_to diary_by_date_path(date: @diary.date.strftime('%Y-%m-%d')), notice: 'You updated your diary.'
    else
      redirect_to root_path, alert: 'You were unable to update a diary. Please contact your administrator.'
    end
  end

  private
    def diary_params
      params.require(:diary).permit(:title, :content, :user_id, :date)
    end

    def get_random_prompt(category)
      PROMPTS[category.to_sym]&.sample
    end
end
