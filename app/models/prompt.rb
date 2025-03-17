class Prompt < ApplicationRecord
  belongs_to :battle

  validates :content, presence: true
end
