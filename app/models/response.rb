class Response < ApplicationRecord
  belongs_to :battle
  has_many :votes

  validates :model, presence: true

  # ICONS = ["keyboard", "magnifying-glass", "comments", "calculator"]

  # CATEGORIES = ["Content generation", "Research", "Discussion", "Mathematics"]

  # CAT = [["Content generation",]]

  CATEGORIES = {
    Content: 'keyboard',
    Research: 'magnifying-glass',
    Discussion: 'comments',
    Mathematics: 'calculator'
  }

  DURATIONS = {
    '30 mins': (DateTime.now + 30.minutes),
    '1 hour': (DateTime.now + 1.hour),
    '2 hours': (DateTime.now + 2.hours),
    '1 day': (DateTime.now + 1.day)
  }
end
