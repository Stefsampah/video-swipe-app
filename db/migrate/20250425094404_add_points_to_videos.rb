class AddPointsToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :points, :integer
  end
end
