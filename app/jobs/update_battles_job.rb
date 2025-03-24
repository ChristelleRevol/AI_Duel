class UpdateBattlesJob < ApplicationJob
  queue_as :default

  def perform
    Battle.where(winner: nil).where('end_date < ?', DateTime.now).each do |battle|
      best_response_id = battle.votes.group(:response_id).count.max_by { |_k, v| v }.first
      battle.update(winner: Response.find(best_response_id).model)
    end
  end
end
