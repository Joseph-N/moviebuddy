class RegistrationsController < Devise::RegistrationsController

  def new
    @recent_movies = Movie.where(popular: false).last(5)
    @random_movie = Movie.where(popular: true).sample
    @tmdb = Tmdb.new
    @image = @tmdb.imageUrl('backdrop','original', @random_movie.backdrop)
    super
  end

end 