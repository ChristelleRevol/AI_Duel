class Battle < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :votes

  validates :category, :end_date, :prompt, presence: true

  def mistral_response
    set_mistral_response if responses.find_by(model: "Mistral").nil?
    responses.find_by(model: "Mistral")
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
    )
    puts "c'est la"
    puts content
    # content.parsed_response["choices"][0]["message"]["content"]
    Response.create(model: "Mistral", content: content, battle: self)
  end
end
