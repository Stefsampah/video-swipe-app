module Admin
  class PlaylistsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def new
      @playlist = Playlist.new
    end

    def create
      @playlist = Playlist.new(playlist_params)
      youtube_service = YoutubeService.new
      
      begin
        videos = youtube_service.get_playlist_videos(params[:youtube_playlist_id])
        
        if videos.empty?
          flash[:alert] = "No videos found in the playlist"
          render :new
          return
        end

        if @playlist.save
          videos.each do |video_data|
            @playlist.videos.create!(
              title: video_data[:title],
              youtube_id: video_data[:youtube_id]
            )
          end
          redirect_to @playlist, notice: 'Playlist was successfully created.'
        else
          render :new
        end
      rescue StandardError => e
        flash[:alert] = "Error importing playlist: #{e.message}"
        render :new
      end
    end

    private

    def playlist_params
      params.require(:playlist).permit(:title, :description)
    end

    def require_admin
      unless current_user.admin?
        flash[:alert] = "You don't have permission to access this page"
        redirect_to root_path
      end
    end
  end
end 