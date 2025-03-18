class Battle < ApplicationRecord
  belongs_to :user
  has_many :responses, :votes

  validates :category, :end_date, :prompt, presence: true
end
