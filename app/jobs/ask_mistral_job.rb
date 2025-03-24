class AskMistralJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_or_create_by(model: "Mistral")
    if response.content.nil?
      content = api_response(battle)
      response.update(content: content)
    end
    broadcast(response, battle)
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
    )['choices'][0]['message']['content']
  end

  def broadcast(response, battle)
    Turbo::StreamsChannel.broadcast_update_to(
      "response_#{response.id}",
      target: "response_#{response.id}",
      partial: "battles/response",
      locals: { response: response, battle: battle }
    )
  end
end
