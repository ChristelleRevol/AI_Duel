class AskOpenAiJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_by(model: "OpenAI")
    client = OpenAI::Client.new
    content = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: battle.prompt }]
      }
    )["choices"][0]["message"]["content"]
    response.update(content: content) if response.content.nil?
    Turbo::StreamsChannel.broadcast_update_to(
      "response_#{response.id}",
      target: "response_#{response.id}",
      partial: "battles/response", locals: { response: response, battle: battle }
    )
  end
end
