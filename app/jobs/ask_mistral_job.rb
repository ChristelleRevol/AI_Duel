class AskMistralJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_or_create_by(model: "Mistral")
    begin
      if response.content.nil?
        answer = api_response(battle)
        content = answer['choices'][0]['message']['content']
        token = answer['usage']['total_tokens']
        response.update(content: content)
        response.update(token: token)
      end
    rescue HTTParty::Error => e
      Rails.logger.error "HTTParty Error: #{e.message}"
      response.update(content: "API Error")
    rescue StandardError => e
      Rails.logger.error "General Error : #{e.message}"
      response.update(content: "an unknown error has occurred")
    ensure
      broadcast(response, battle)
    end
  end

  private

  def api_response(battle)
    HTTParty.post(
      "https://api.mistral.ai/v1/chat/completions",
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authorization" => "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"
      },
      body: { model: "mistral-large-latest",
              messages: [
                { role: "system", content: "You're an expert in the following field: #{battle.category}" },
                { role: "user", content: battle.prompt }
              ] }.to_json
    )
  end

  def broadcast(response, battle)
    Turbo::StreamsChannel.broadcast_update_to(
      "response_#{response.id}",
      target: "response_#{response.id}",
      partial: "battles/response",
      locals: { response: response, battle: battle, user: battle.user }
    )
  end
end
