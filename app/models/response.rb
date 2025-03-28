class Response < ApplicationRecord
  belongs_to :battle
  has_many :votes

  validates :model, presence: true

  CATEGORIES = {
    keyboard: 'Content',
    'magnifying-glass': 'Research',
    comments: 'Discussion',
    calculator: 'Mathematics'
  }

  DURATIONS = {
    '30 mins': (DateTime.now + 30.minutes),
    '1 hour': (DateTime.now + 1.hour),
    '2 hours': (DateTime.now + 2.hours),
    '1 day': (DateTime.now + 1.day)
  }
end
