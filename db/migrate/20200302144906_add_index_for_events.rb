class AddIndexForEvents < ActiveRecord::Migration[6.0]
  def change
    add_index :events, [:held_at]
    add_index :events, [:extract_from]
    add_index :events, [:held_at, :extract_from]
  end
end
