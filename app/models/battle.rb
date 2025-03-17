class Battle < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
  has_many :responses

  validates :category, :end_date, presence: true
end
