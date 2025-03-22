class AskMistralJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_by(model: "Mistral")
    content = HTTParty.post(
      "https://api.mistral.ai/v1/chat/completions",
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authorization" => "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"
      },
      body: {
        model: "mistral-large-latest",
        messages: [{ role: "user", content: battle.prompt }]
      }.to_json
    )['choices'][0]['message']['content']
    response.update(content: content) if response.content.nil?
    Turbo::StreamsChannel.broadcast_update_to(
      "response_#{response.id}",
      target: "response_#{response.id}",
      partial: "battles/response", locals: { response: response, battle: response.battle }
    )
  end
end
