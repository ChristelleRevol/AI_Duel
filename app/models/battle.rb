class Battle < ApplicationRecord
  belongs_to :user
  has_many :responses
  has_many :votes

  validates :category, :end_date, :prompt, presence: true
  after_save :async_responses_call

  private

  def async_responses_call
    jobs = [AskClaudeJob.new(self), AskOpenAiJob.new(self), AskMistralJob.new(self)]
    ActiveJob.perform_all_later(jobs)
  end
end
