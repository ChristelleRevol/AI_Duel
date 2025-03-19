class Vote < ApplicationRecord
  belongs_to :battle
  belongs_to :user
  belongs_to :response

  def self.user_voted?(user, battle)
    exists?(user: user, battle: battle)
  end
end
