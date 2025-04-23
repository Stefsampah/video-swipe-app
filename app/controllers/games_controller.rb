class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:new, :create, :show]
  before_action :set_game, only: [:show, :swipe]

  def new
    @game = Game.new(playlist: @playlist, user: current_user)
  end

  def create
    @game = Game.new(playlist: @playlist, user: current_user)
    
    if @game.save
      redirect_to playlist_game_path(@playlist, @game), notice: "Partie créée avec succès !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    if @game.completed?
      redirect_to playlists_path, notice: "Vous avez terminé cette playlist !"
    end
  end

  def swipe
    video = @game.current_video
    action = params[:action] == "like" ? "like" : "dislike"

    # Créer le swipe
    swipe = @game.swipes.create!(
      user: current_user,
      video: video,
      action: action
    )

    # Calculer les points en fonction de l'action
    points = case action
             when "like" then 2
             when "dislike" then 1
             end

    # Mettre à jour ou créer le score
    score = Score.find_or_initialize_by(user: current_user, playlist: @game.playlist)
    score.points = (score.points || 0) + points
    score.save!

    # Forcer le rechargement du jeu
    @game.reload

    # Passer à la vidéo suivante
    if @game.next_video
      redirect_to playlist_game_path(@game.playlist, @game), notice: "Vidéo #{action == 'like' ? 'aimée' : 'pas aimée'} !"
    else
      redirect_to playlists_path, notice: "Félicitations ! Vous avez terminé la playlist !"
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
