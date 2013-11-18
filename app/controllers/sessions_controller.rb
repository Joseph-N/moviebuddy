class SessionsController < Devise::SessionsController

  def new
    @recent_movies = Movie.where(popular: false).last(5)
    @random_movie = Movie.where(popular: true).sample
    @tmdb = Tmdb.new
    @image = @tmdb.imageUrl('backdrop','original', @random_movie.backdrop) if @random_movie
    super
  end

end 