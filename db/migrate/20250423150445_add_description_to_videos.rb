class AddDescriptionToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :description, :text
  end
end
