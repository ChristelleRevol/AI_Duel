class Response < ApplicationRecord
  belongs_to :battle

  validates :model, presence: true
end
