class AskClaudeJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_or_create_by(model: "Claude")
    begin
      if response.content.nil?
        content = api_response(battle)['content'][0]['text']
        token = api_response(battle)['usage']['input_tokens'] + api_response(battle)['usage']['output_tokens']
        response.update(content: content)
        response.update(token: token)
      end
    rescue Anthropic::Error => e
      Rails.logger.error "Anthropic Error: #{e.message}"
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
    client = Anthropic::Client.new
    client.messages(
      parameters: {
        model: "claude-3-haiku-20240307",
        system: "You're an expert in the following field: #{battle.category}",
        messages: [{ role: "user", content: battle.prompt }],
        max_tokens: 1000
      }
    )
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
