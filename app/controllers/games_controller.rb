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
      # Récupérer les informations nécessaires
      @score = Score.find_by(user: current_user, playlist: @game.playlist)
      @playlist = @game.playlist
  
      # Calcul des vidéos likées, non likées et swipées
      swipes = @game.swipes.includes(:video)
      @liked_videos = swipes.where(action: "like").map(&:video)
      @not_liked_videos = swipes.where(action: "dislike").map(&:video)
      @swiped_videos = swipes.map(&:video) # Récupère toutes les vidéos swipées (likées + non likées)
  
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
    
  
  
  def swipe
    # Étape 1 : Log des paramètres reçus
    Rails.logger.info "Params reçus : #{params.inspect}"
  
    video = @game.current_video
    action = params[:direction] == "like" ? "like" : "dislike"
  
    # Étape 2 : Log de la valeur de liked_value et autres données avant création
    liked_value = (action == "like")
    Rails.logger.info "Type de liked_value : #{liked_value.class} | Valeur : #{liked_value}"
    Rails.logger.info "Vidéo actuelle : #{video&.title} | Utilisateur : #{current_user&.id} | Action : #{action}"
  
    # Créer le swipe
    swipe = @game.swipes.create!(
      user: current_user,
      video: video,
      action: action,
      liked: liked_value
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
  
    # Vérifier s'il y a une vidéo suivante
    next_video = @game.next_video
    Rails.logger.info "Vidéo suivante: #{next_video&.title}"
  
    # Passer à la vidéo suivante
    if next_video
      redirect_to playlist_game_path(@game.playlist, @game), notice: "Vidéo #{action == 'like' ? 'like' : 'dislike'} !"
    else
      redirect_to playlists_path, notice: "Félicitations ! Vous avez terminé la playlist !"
    end
  end
  
  def play
    @playlist = Playlist.find(params[:playlist_id])
    @game = Game.new(playlist: @playlist, user: current_user)
  
    if @game.save
      redirect_to playlist_game_path(@playlist, @game), notice: "Nouvelle partie lancée !"
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
