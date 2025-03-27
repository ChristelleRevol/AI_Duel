class UpdateBattlesJob < ApplicationJob
  queue_as :default

  def perform
    return unless Battle.where(winner: nil).where('end_date < ?', DateTime.now).any?

    Battle.where(winner: nil).where('end_date < ?', DateTime.now).each do |battle|
      response_votes = battle.votes.group(:response_id).count
      if response_votes.empty?
        battle.update(end_date: battle.end_date + 1.hour)
      else
        best_response_id = response_votes.max_by { |_k, v| v }.first
        battle.update(winner: Response.find(best_response_id).model)
      end
    end
  end
end
