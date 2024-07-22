class ChatGptService
  require 'openai'

  def initialize
    @openai = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def evaluate_diary(title, content)
    prompt = generate_diary_prompt(title, content)
    response = @openai.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "system", content: "You are a helpful assistant who specializes in providing detailed feedback on grammar, spelling, and sentence structure in simple, plain English, and suggesting improvements to clarity, expression, and grammatical accuracy." },
          { role: "user", content: prompt }
        ],
        temperature: 0.7,
        max_tokens: 500,
      }
    )
    # レスポンスからJSONコンテンツを抽出して解析する
    json_response = response['choices'].first['message']['content']
    json_response.gsub!(/```json|```/, '')  # Markdownフォーマットを取り除く

    begin
      parsed_response = JSON.parse(json_response)
      valid_json_response = JSON.pretty_generate(parsed_response)
    rescue JSON::ParserError => e
      puts "JSON解析エラー: #{e.message}"
      return nil
    end
  
    valid_json_response
  end

  def generate_follow_up_question(prompt)
    adjusted_prompt = <<~PROMPT
      You are a helpful assistant that generates short and simple follow-up questions based on your input. Given the prompt below, please generate a concise follow-up question in both English and Japanese, formatted in JSON with keys 'en' for English and 'ja' for Japanese. Do not include any other text or formatting in the response.
      Prompt: "#{prompt}"
      Question:
    PROMPT
  
    response = @openai.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "system", content: adjusted_prompt },
          { role: "user", content: "Please generate a question in the specified format." }
        ],
        temperature: 0.5,
        max_tokens: 60,
      }
    )
  
    # レスポンスからJSONコンテンツを抽出して解析する
    json_response = response['choices'].first['message']['content']
    json_response.gsub!(/```json|```/, '')  # Markdownフォーマットを取り除く
  
    begin
      parsed_response = JSON.parse(json_response)
    rescue JSON::ParserError => e
      puts "JSON解析エラー: #{e.message}"
      return nil
    end
  
    parsed_response
  end

  private

  def generate_diary_prompt(title, content)
    <<~PROMPT
      The following is a diary entry titled '#{title}':
      
      #{content}
      
      Please provide feedback on this diary in a structured format as follows:
      - "grammar_errors": Lists suggested corrections for grammatical errors in an array.
      - "sentence_structure": Provide advice in array on how to improve sentence construction for better clarity.
      - "useful_phrases": To improve clarity and expressiveness, please suggest useful phrases that can be used within this diary entry in an easy-to-understand, sequenced format.

      Make sure the response is a valid JSON object.
  PROMPT
  end
  
end
