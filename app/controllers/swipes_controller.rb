class SwipesController < ApplicationController
  before_action :authenticate_user!

  def create
    video = Video.find(params[:video_id])
    playlist = Playlist.find(params[:playlist_id])
    
    # Créer un enregistrement de swipe
    Swipe.create!(
      user: current_user,
      video: video,
      playlist: playlist,
      liked: params[:liked]
    )

    # Mettre à jour le score si c'est un like
    if params[:liked]
      score = Score.find_or_create_by!(user: current_user, playlist: playlist)
      score.increment!(:points)
    end

    head :ok
  end
end 