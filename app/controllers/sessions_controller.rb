class SessionsController < Devise::SessionsController

  def new
    @recent_movies = Movie.where('popular = ? and upcoming = ? and highest_rated = ?', false, false, false).last(10)
    @random_movie = Movie.where(popular: true).sample
    @tmdb = Tmdb.new
    @image = @tmdb.imageUrl('backdrop','original', @random_movie.backdrop) if @random_movie
    super
  end

end 