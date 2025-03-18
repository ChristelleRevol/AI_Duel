class DropPrompts < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :battles, :prompts
    drop_table :prompts
  end
end
