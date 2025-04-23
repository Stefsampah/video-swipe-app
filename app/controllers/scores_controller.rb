class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    # Récupérer tous les utilisateurs avec leurs avatars
    @users = User.includes(:avatar_attachment).all
    
    # Calculer les différents types de scores
    @top_engager_scores = Score.calculate_top_engager_scores
    @best_ratio_scores = Score.calculate_best_ratio_scores
    @wise_critic_scores = Score.calculate_wise_critic_scores
    @total_scores = Score.calculate_total_scores

    # Récupérer les scores par playlist
    @scores_by_playlist = Playlist.includes(scores: :user).all.map do |playlist|
      [playlist, playlist.scores.order(points: :desc)]
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
    @scores = Score.includes(:user)
                  .where(playlist: @playlist)
                  .order(points: :desc)
  end
end
