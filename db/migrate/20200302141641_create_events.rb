class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.datetime :held_at
      t.string :title
      t.string :img_url
      t.string :link
      t.string :extract_from

      t.timestamps
    end
  end
end
