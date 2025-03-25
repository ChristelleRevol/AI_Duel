class AddTokenToResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :responses, :token, :integer
  end
end
