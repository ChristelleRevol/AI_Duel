class Battle < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :votes

  validates :category, :end_date, :prompt, presence: true

  def mistral_response
    set_mistral_response if responses.find_by(model: "Mistral").nil?
    responses.find_by(model: "Mistral")
  end

  def claude_response
    # set_claude_response if responses.find_by(model: "Claude").nil?
    # responses.find_by(model: "Claude")
  end

  private

  def set_mistral_response
    # content = HTTParty.post(
    #   "https://api.mistral.ai/v1/chat/completions",
    #   headers: {
    #     "Content-Type" => "application/json",
    #     "Accept" => "application/json",
    #     "Authorization" => "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"
    #   },
    #   body: {
    #     model: "mistral-large-latest",
    #     messages: [{ role: "user", content: prompt }]
    #   }.to_json
    # )

    # uri = URI("https://api.mistral.ai/v1/chat/completions")
    # request = Net::HTTP::Post.new(uri)
    # request["Content-Type"] = "application/json"
    # request["Accept"] = "application/json"
    # request["Authorization"] = "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"

    # request.body = {
    #   model: "mistral-large-latest",
    #   messages: [{ role: "user", content: prompt }]
    # }.to_json

    # answer = content.parsed_response.dig("choices", 0, "message", "content")
    # # answer = content.parsed_response["choices"][0]["message"]["content"]
    # Response.create(model: "Mistral", content: answer, battle: self)

    client = Mistral::Client.new

    response = client.chat(
      model: "mistral-large-latest",
      messages: [{ role: "user", content: prompt }]
    )

    answer = response.dig("choices", 0, "message", "content")
    Response.create(model: "Mistral", content: answer, battle: self)
  end

  def set_claude_response
    client = Anthropic::Client.new
    content = client.messages(
      parameters: {
        model: "claude-3-haiku-20240307",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 1000
      }
    )['content'][0]['text']
    Response.create(model: "Claude", content: content, battle: self)
  end
end
