class CreateSwipes < ActiveRecord::Migration[7.1]
  def change
    create_table :swipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.boolean :liked, null: false

      t.timestamps
    end

    add_index :swipes, [:user_id, :video_id, :game_id], unique: true
  end
end 