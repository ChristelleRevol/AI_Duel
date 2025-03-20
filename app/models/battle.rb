class Battle < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :votes

  validates :category, :end_date, :prompt, presence: true

  def claude_response
    set_claude_response if responses.find_by(model: "Claude").nil?
    responses.find_by(model: "Claude")
  end

  private

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
