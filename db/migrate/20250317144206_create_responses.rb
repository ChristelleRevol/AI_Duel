class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.integer :votes
      t.string :model
      t.references :battle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
