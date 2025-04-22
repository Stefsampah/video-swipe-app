class YoutubeService
  def initialize
    @client = Google::Apis::YoutubeV3::YouTubeService.new
    @client.key = ENV['YOUTUBE_API_KEY']
  end

  def get_video_info(video_id)
    begin
      response = @client.list_videos('snippet', id: video_id)
      video = response.items.first
      return nil unless video

      {
        title: video.snippet.title,
        description: video.snippet.description,
        thumbnail_url: video.snippet.thumbnails.default.url
      }
    rescue Google::Apis::Error => e
      Rails.logger.error "YouTube API Error: #{e.message}"
      nil
    end
  end

  def get_playlist_videos(playlist_id)
    begin
      response = @client.list_playlist_items('snippet', playlist_id: playlist_id, max_results: 50)
      response.items.map do |item|
        {
          title: item.snippet.title,
          youtube_id: item.snippet.resource_id.video_id,
          description: item.snippet.description
        }
      end
    rescue Google::Apis::Error => e
      Rails.logger.error "YouTube API Error: #{e.message}"
      []
    end
  end
end 