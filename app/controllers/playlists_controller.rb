class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @playlists = Playlist.all
  end

  def show
    @playlist = Playlist.find(params[:id])
    
    # Récupérer les vidéos non encore swipées par l'utilisateur
    swiped_video_ids = current_user.swipes.where(playlist: @playlist).pluck(:video_id)
    @current_video = @playlist.videos.where.not(id: swiped_video_ids).first
  end
end
