class AskClaudeJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_by(model: "Claude")
    client = Anthropic::Client.new
    content = client.messages(
      parameters: {
        model: "claude-3-haiku-20240307",
        messages: [{ role: "user", content: battle.prompt }],
        max_tokens: 1000
      }
    )['content'][0]['text']
    response.update(content: content) if response.content.nil?
    Turbo::StreamsChannel.broadcast_update_to(
      "response_#{response.id}",
      target: "response_#{response.id}",
      partial: "battles/response", locals: { response: response, battle: battle }
    )
  end
end
