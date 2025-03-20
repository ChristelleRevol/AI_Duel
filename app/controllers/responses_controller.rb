class ResponsesController < ApplicationController
  def index
  end

  def stream_mistral
    prompt = params[:prompt]

    # response = HTTParty.post(
    #   "https://api.mistral.ai/v1/chat/completions",
    #   headers: {
    #     "Content-Type" => "application/json",
    #     "Accept" => "application/json",
    #     "Authorization" => "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"
    #   },
    #   body: {
    #     model: "mistral-large-latest",
    #     messages: [{ role: "user", content: prompt }]
    #   }.to_json
    # )
    # @ai_response = response.parsed_response
    # @response = Response.new(model: "Mistral", content: @ai_response)
    # @response.save
    # render :index


    client = Mistral::Client.new

    response = client.chat(
      model: "mistral-large-latest",
      messages: [{ role: "user", content: prompt }]
    )['choices'][0]['message']['content']

    # answer = response.dig("choices", 0, "message", "content")
    Response.create(model: "Mistral", content: response, battle: self)
  end
end
