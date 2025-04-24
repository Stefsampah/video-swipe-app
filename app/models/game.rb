class Game < ApplicationRecord
  belongs_to :user
  belongs_to :playlist
  has_many :swipes, dependent: :destroy
  has_many :videos, through: :swipes

  validates :user, presence: true
  validates :playlist, presence: true

  def current_video
    # Récupérer tous les IDs des vidéos déjà swipées
    swiped_video_ids = swipes.pluck(:video_id)
    
    # Trouver la première vidéo qui n'a pas été swipée
    playlist.videos.where.not(id: swiped_video_ids).first
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
    Rails.logger.info "Début du swipe avec direction : #{direction}"
    return if completed?
  
    video = current_video
    Rails.logger.info "Vidéos déjà swipées : #{swipes.pluck(:video_id)}"
    Rails.logger.info "Vidéo actuelle : #{video&.title}"
  
    # Assurez-vous qu'une vidéo existe avant de continuer
    return unless video

  
    begin
      # Définir la valeur pour le champ 'liked' en fonction de la direction
      liked_value = direction == "like"
      # Ajout du débogueur pour inspecter les valeurs
      byebug
      liked_value
      direction
      video.inspect
      params.inspect

       # Ajouter les logs ici pour inspecter les valeurs
    Rails.logger.info "Valeur de liked_value : #{liked_value}"
    Rails.logger.info "Direction : #{direction}"
    Rails.logger.info "Vidéo actuelle : #{video&.title}"
      # Créer le swipe avec toutes les données nécessaires
      new_swipe = swipes.create!(
        video: video,
        action: direction,
        liked: liked_value,
        user: user
      )
  
      Rails.logger.info "Swipe créé avec succès : #{new_swipe.inspect}"
  
      # Recharger les données pour s'assurer de la mise à jour des associations
      reload
  
      # Retourner la prochaine vidéo non swipée
      next_video
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erreur lors de la création du Swipe : #{e.message}"
      nil
    end
  end
  

  def score
    swipes.where(action: 'like').count * 2 + swipes.where(action: 'dislike').count
  end
end 