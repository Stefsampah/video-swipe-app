class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :scores
  has_many :swipes
  has_many :videos, through: :swipes
  has_many :playlists, through: :swipes
end
