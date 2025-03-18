class Response < ApplicationRecord
  belongs_to :battle
  has_many :votes

  validates :model, presence: true
end
