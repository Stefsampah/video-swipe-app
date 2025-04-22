class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    # Récupérer tous les utilisateurs avec leurs scores
    @users = User.includes(:scores, :avatar_attachment)
    
    # Calculer les scores totaux pour chaque utilisateur
    @total_scores = Score.group(:user_id).sum(:points)
    
    # Trier les utilisateurs par score total
    @users = @users.sort_by { |user| -(@total_scores[user.id] || 0) }
    
    # Récupérer tous les scores par playlist
    @scores_by_playlist = Score.includes(:user, :playlist)
                              .order(points: :desc)
                              .group_by(&:playlist)
  end

  def show
    @playlist = Playlist.find(params[:id])
    @scores = Score.includes(:user)
                  .where(playlist: @playlist)
                  .order(points: :desc)
  end
end
