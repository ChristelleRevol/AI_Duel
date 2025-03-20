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
    set_claude_response if responses.find_by(model: "Claude").nil?
    responses.find_by(model: "Claude")
  end

  def openai_response
    set_openai_response if responses.find_by(model: "OpenAI").nil?
    responses.find_by(model: "OpenAI")
  end

  private

  def set_mistral_response
    content = HTTParty.post(
      "https://api.mistral.ai/v1/chat/completions",
      headers: {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "Authorization" => "Bearer #{ENV.fetch('MISTRAL_API_KEY') { raise 'Clé API manquante !' }}"
      },
      body: {
        model: "mistral-large-latest",
        messages: [{ role: "user", content: prompt }]
      }.to_json
    )['choices'][0]['message']['content']
    Response.create!(model: "Mistral", content: content, battle: self)
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

  def set_openai_response
    client = OpenAI::Client.new
    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }]
      }
    )["choices"][0]["message"]["content"]
    Response.create(model: "OpenAI", content: chatgpt_response, battle: self)
  end
end
