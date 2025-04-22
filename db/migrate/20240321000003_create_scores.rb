class CreateScores < ActiveRecord::Migration[7.1]
  def change
    create_table :scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true
      t.integer :points, default: 0

      t.timestamps
    end
  end
end 