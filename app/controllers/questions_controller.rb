class QuestionsController < ApplicationController
  def generate_question
    chat_service = ChatGptService.new
    prompt = params[:prompt] # 最初の質問または前のユーザーの回答
    generated_question = chat_service.generate_follow_up_question(prompt)
    render json: generated_question
  end
end
