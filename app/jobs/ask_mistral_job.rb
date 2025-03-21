class AskMistralJob < ApplicationJob
  queue_as :default

  def perform(battle)
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
    Response.create!(model: "Mistral", content: content, battle: battle)
  end
end
