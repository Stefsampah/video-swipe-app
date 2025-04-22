class Score < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: { scope: :playlist_id, message: "has already played this playlist" }
end
