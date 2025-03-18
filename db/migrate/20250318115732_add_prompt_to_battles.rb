class AddPromptToBattles < ActiveRecord::Migration[7.1]
  def change
    add_column :battles, :prompt, :text
  end
end
