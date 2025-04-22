class Game < ApplicationRecord
  belongs_to :user
  belongs_to :playlist
  has_many :swipes, dependent: :destroy
  has_many :videos, through: :playlist

  validates :user, presence: true
  validates :playlist, presence: true

  def current_video
    # Récupérer tous les IDs des vidéos déjà swipées
    swiped_video_ids = swipes.pluck(:video_id)
    
    # Trouver la première vidéo qui n'a pas été swipée
    videos.where.not(id: swiped_video_ids).first
  end

  def swipe(direction)
    Rails.logger.info "Début du swipe avec direction: #{direction}"
    return if completed?

    video = current_video
    Rails.logger.info "Vidéo actuelle: #{video&.title}"
    return unless video

    # Créer le swipe avec l'utilisateur
    new_swipe = swipes.create!(
      video: video,
      liked: direction == 'like',
      user: user
    )
    Rails.logger.info "Swipe créé: #{new_swipe.inspect}"

    # Forcer le rechargement des associations
    reload

    # Retourner la prochaine vidéo
    next_video = current_video
    Rails.logger.info "Prochaine vidéo: #{next_video&.title}"
    next_video
  end

  def completed?
    # Vérifier si toutes les vidéos ont été swipées
    videos.count == swipes.count
  end

  def score
    swipes.where(liked: true).count
  end
end 