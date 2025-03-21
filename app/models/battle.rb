class Battle < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :votes

  validates :category, :end_date, :prompt, presence: true

  after_save :async_responses_call

  private

  def async_responses_call
    AskClaudeJob.perform_later(self)
    AskOpenAiJob.perform_later(self)
    AskMistralJob.perform_later(self)
  end
end
