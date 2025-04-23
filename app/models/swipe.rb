class Swipe < ApplicationRecord
  belongs_to :user
  belongs_to :video
  belongs_to :game

  validates :user_id, uniqueness: { scope: [:video_id, :game_id] }
  validates :liked, inclusion: { in: [true, false] }
  validates :action, presence: true, inclusion: { in: %w[like dislike] }
end 