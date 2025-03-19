class RemoveVotesFromResponses < ActiveRecord::Migration[7.1]
  def change
    remove_column :responses, :votes
  end
end
