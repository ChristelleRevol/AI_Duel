class AskClaudeJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_or_create_by(model: "Claude")
    if response.content.nil?
      content = api_response(battle.prompt)
      response.update(content: content)
    end
    broadcast(response, battle)
  end

  private

  def api_response(prompt)
    client = Anthropic::Client.new
    client.messages(
      parameters: {
        model: "claude-3-haiku-20240307",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 1000
      }
    )['content'][0]['text']
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
