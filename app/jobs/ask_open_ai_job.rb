class AskOpenAiJob < ApplicationJob
  queue_as :default

  def perform(battle)
    # client = OpenAI::Client.new
    # chatgpt_response = client.chat(
    #   parameters: {
    #     model: "gpt-4o-mini",
    #     messages: [{ role: "user", content: battle.prompt }]
    #   }
    # )["choices"][0]["message"]["content"]
    # Response.create(model: "OpenAI", content: chatgpt_response, battle: battle)
    content = "blablabla"
    sleep(3)
    response = battle.responses.find_by(model: "OpenAI")
    response.update(content: content) if response.content.nil?
    Turbo::StreamsChannel.broadcast_update_to(
      "response_#{@response.id}",
      target: "response_#{@response.id}",
      partial: "battles/response", locals: { response: response, battle: response.battle })
  end
end
