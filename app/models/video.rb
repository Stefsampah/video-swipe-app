class Video < ApplicationRecord
  belongs_to :playlist
  has_many :swipes
  validates :title, presence: true
  validates :youtube_id, presence: true, uniqueness: { scope: :playlist_id }

  def points
    swipes.where(action: "like").count * 2 || 0
  end

end
