class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :video_id
      t.string :text
      t.integer :timestamp
      t.integer :duration

      t.timestamps
    end
  end
end
