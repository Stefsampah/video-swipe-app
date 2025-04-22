class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:new, :create, :show, :swipe]
  before_action :set_game, only: [:show, :swipe]

  def new
    @game = Game.new(playlist: @playlist, user: current_user)
  end

  def create
    @game = Game.new(playlist: @playlist, user: current_user)
    
    if @game.save
      redirect_to playlist_game_path(@playlist, @game)
    else
      redirect_to @playlist, alert: 'Impossible de démarrer le jeu.'
    end
  end

  def show
    @game.reload  # Forcer le rechargement du jeu
    @current_video = @game.current_video
    @score = @game.score

    if @current_video.nil?
      redirect_to playlists_path, notice: 'Jeu terminé ! Score final : ' + @score.to_s
    end
  end

  def swipe
    direction = params[:direction]
    Rails.logger.info "Direction reçue : #{direction}"
    Rails.logger.info "État initial - Vidéos swipées : #{@game.swipes.count}"
    
    next_video = @game.swipe(direction)
    @game.reload  # Recharger le jeu après le swipe
    
    Rails.logger.info "État final - Vidéos swipées : #{@game.swipes.count}"
    Rails.logger.info "Prochaine vidéo : #{next_video&.title}"
    
    if next_video.nil?
      redirect_to playlists_path, notice: 'Jeu terminé ! Score final : ' + @game.score.to_s
    else
      flash[:notice] = direction == 'like' ? '👍 Liked!' : '👎 Disliked!'
      redirect_to playlist_game_path(@playlist, @game)
    end
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:playlist_id])
  end

  def set_game
    @game = Game.find(params[:id])
  end
end
