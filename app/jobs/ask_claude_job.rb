class AskClaudeJob < ApplicationJob
  queue_as :default

  def perform(battle)
    # client = Anthropic::Client.new
    # content = client.messages(
    #   parameters: {
    #     model: "claude-3-haiku-20240307",
    #     messages: [{ role: "user", content: battle.prompt }],
    #     max_tokens: 1000
    #   }
    # )['content'][0]['text']
    content = "blablabla"
    sleep(3)
    response = battle.responses.find_by(model: "Claude")
    response.update(content: content)
  end
end
