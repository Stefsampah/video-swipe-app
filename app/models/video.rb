class Video < ApplicationRecord
  belongs_to :playlist

  validates :title, presence: true
  validates :youtube_id, presence: true, uniqueness: { scope: :playlist_id }
end
