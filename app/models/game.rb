class Game < ApplicationRecord
  belongs_to :user
  belongs_to :playlist
  has_many :swipes, dependent: :destroy
  has_many :videos, through: :swipes

  validates :user, presence: true
  validates :playlist, presence: true

  def current_video
    # Récupérer la première vidéo de la playlist qui n'a pas encore été swipée
    playlist.videos.where.not(id: swipes.select(:video_id)).first
  end

  def next_video
    # Recharger les associations pour s'assurer d'avoir les dernières données
    reload
    current_video
  end

  def completed?
    # Le jeu est terminé quand toutes les vidéos ont été swipées
    reload
    swipes.count >= playlist.videos.count
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
      action: direction,
      user: user
    )
    Rails.logger.info "Swipe créé: #{new_swipe.inspect}"

    # Forcer le rechargement des associations
    reload

    # Retourner la prochaine vidéo
    next_video
  end

  def score
    swipes.where(action: 'like').count * 2 + swipes.where(action: 'dislike').count
  end
end 