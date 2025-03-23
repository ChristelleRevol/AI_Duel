class AskOpenAiJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_or_create_by(model: "OpenAI")
    if response.content.nil?
      content = api_response(battle.prompt)
      response.update(content: content)
    end
    broadcast(response, battle)
  end

  private

  def api_response(prompt)
    client = OpenAI::Client.new
    client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }]
      }
    )["choices"][0]["message"]["content"]
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
