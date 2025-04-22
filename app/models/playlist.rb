class Playlist < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :scores
  has_many :users, through: :scores

  validates :title, presence: true
  validates :description, presence: true
end
