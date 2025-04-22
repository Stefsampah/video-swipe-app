class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @scores = Score.includes(:user, :playlist)
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
