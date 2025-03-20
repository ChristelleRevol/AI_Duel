#require 'httparty'

class ResponsesController < ApplicationController
  # include ActionController::Live

  def index
  end

  def stream_mistral
    content_prompt = params[:prompt]

    response = HTTParty.post(
      "https://api.mistral.ai/v1/chat/completions",
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authorization" => "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"
      },
      body: {
        model: "mistral-large-latest",
        messages: [{ role: "user", content: content_prompt }]
      }.to_json
    )
    @ai_response = response.parsed_response
    @response = Response.new(model: "Mistral", content: @ai_response)
    @response.save
    render :index
  end
end
