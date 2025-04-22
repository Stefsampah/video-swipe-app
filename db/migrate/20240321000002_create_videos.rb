class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :youtube_id
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end 