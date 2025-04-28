class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:new, :create, :show, :swipe, :results]
  before_action :set_game, only: [:show, :swipe, :results]

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
      # Récupérer les informations nécessaires
      @score = Score.find_by(user: current_user, playlist: @game.playlist)
      @playlist = @game.playlist
      
      # Calcul des vidéos likées et non likées
      swipes = @game.swipes.includes(:video)
      @liked_videos = swipes.where(action: "like").map(&:video)
      @not_liked_videos = @playlist.videos - @liked_videos # Toutes les vidéos - vidéos likées

      # Calcul de la position dans le classement
      scores = Score.where(playlist: @playlist).order(points: :desc)
      @position = scores.pluck(:user_id).index(current_user.id) + 1

      # Affiche la vue des résultats
      render :results
    else
      # Continuer le jeu (affichez la vue normale du jeu)
      render :show
    end
  end

  def results
    # Récupérer les informations nécessaires
    @score = Score.find_by(user: current_user, playlist: @game.playlist)
    @playlist = @game.playlist
    
    # Calcul des vidéos likées et non likées
    swipes = @game.swipes.includes(:video)
    @liked_videos = swipes.where(action: "like").map(&:video)
    @not_liked_videos = @playlist.videos - @liked_videos # Toutes les vidéos - vidéos likées

    # Calcul de la position dans le classement
    scores = Score.where(playlist: @playlist).order(points: :desc)
    @position = scores.pluck(:user_id).index(current_user.id) + 1
  end

  def swipe
    Rails.logger.info "Params reçus : #{params.inspect}"

    video = @game.current_video
    action = params[:direction] == "like" ? "like" : "dislike"
    liked_value = (action == "like")

    Rails.logger.info "Vidéo actuelle : #{video&.title} | Utilisateur : #{current_user&.id} | Action : #{action}"

    # Créer le swipe
    swipe = @game.swipes.create!(
      user: current_user,
      video: video,
      action: action,
      liked: liked_value
    )

    # Calcul des points en fonction de l'action
    points = action == "like" ? 2 : 1

    # Mettre à jour ou créer le score
    score = Score.find_or_initialize_by(user: current_user, playlist: @game.playlist)
    score.points = (score.points || 0) + points
    score.save!

    @game.reload

    next_video = @game.next_video
    Rails.logger.info "Vidéo suivante : #{next_video&.title}"

    if next_video
      redirect_to playlist_game_path(@game.playlist, @game), notice: "Vidéo #{action} enregistrée !"
    else
      redirect_to playlist_game_results_path(@game.playlist, @game), notice: "Félicitations ! Vous avez terminé la playlist !"
    end
  end

  def play
    @playlist = Playlist.find(params[:playlist_id])
    @game = Game.new(playlist: @playlist, user: current_user)
    
    if @game.save
      redirect_to playlist_game_path(@playlist, @game), notice: "Nouvelle partie lancée !"
    else
      redirect_to playlists_path, alert: "Impossible de lancer une nouvelle partie."
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
