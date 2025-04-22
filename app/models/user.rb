class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games
  has_many :swipes
  has_many :scores
  has_many :videos, through: :swipes
  has_many :playlists, through: :swipes
  has_one_attached :avatar
end
