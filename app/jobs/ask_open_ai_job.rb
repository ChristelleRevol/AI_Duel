class AskOpenAiJob < ApplicationJob
  queue_as :default

  def perform(battle)
    response = battle.responses.find_or_create_by(model: "OpenAI")
    begin
      if response.content.nil?
        content = api_response(battle)["choices"][0]["message"]["content"]
        token = api_response(battle)["usage"]["total_tokens"]
        response.update(content: content)
        response.update(token: token)
      end
    rescue OpenAI::Error => e
      Rails.logger.error "OpenAI Error: #{e.message}"
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
    client = OpenAI::Client.new
    client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "You're an expert in the following field: #{battle.category}" },
          { role: "user", content: "#{battle.prompt}"}
        ]
      }
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
