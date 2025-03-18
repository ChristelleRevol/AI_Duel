class AddContentToResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :responses, :content, :text
  end
end
